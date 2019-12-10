package org.sa.rainbow.translator.effectors;

import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import org.sa.rainbow.monitor.EffectorMonitor;

import java.util.List;

/** @author Carlos Mendes (cmendesce@gmail.com) */
public class RollOutEffector extends KubeEffector {

  public RollOutEffector(String refID, String name) {
    super(refID, name);
  }

  @Override
  protected Outcome internalExecute(List<String> args) {
    var namespace = args.get(0);
    var deployment = args.get(1);
    var container = args.get(2);
    var image = args.get(3);
    var timer = EffectorMonitor.latency().labels("rollOut", namespace, deployment).startTimer();

    try (var client = new DefaultKubernetesClient()) {
      var response =
          client
              .apps()
              .deployments()
              .inNamespace(namespace)
              .withName(deployment)
              .edit()
              .editSpec()
              .editTemplate()
              .editSpec()
              .editMatchingContainer(p -> p.getName().equals(container))
              .withImage(image)
              .endContainer()
              .endSpec()
              .endTemplate()
              .endSpec()
              .done();

      var hasAny =
          response.getSpec().getTemplate().getSpec().getContainers().stream()
              .allMatch(c -> c.getName().equals(container) && c.getImage().equals(image));

      if (hasAny) {
        return Outcome.SUCCESS;
      } else {
        return Outcome.FAILURE;
      }
    } catch (Exception ex) {
      return Outcome.FAILURE;
    } finally {
      timer.observeDuration();
    }
  }
}
