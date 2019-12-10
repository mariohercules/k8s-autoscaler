package org.sa.rainbow.translator.effectors;

import io.fabric8.kubernetes.client.DefaultKubernetesClient;
import org.sa.rainbow.monitor.EffectorMonitor;

import java.util.List;

/** @author Carlos Mendes (cmendesce@gmail.com) */
public class ScaleDownEffector extends KubeEffector {

  public ScaleDownEffector(String refID, String name) {
    super(refID, name);
  }

  @Override
  protected Outcome internalExecute(List<String> args) {
    var namespace = args.get(0);
    var deployment = args.get(1);
    var count = Integer.parseInt(args.get(2));
    var timer = EffectorMonitor.latency().labels("scaleDown", namespace, deployment).startTimer();

    try (var client = new DefaultKubernetesClient()) {
      var replicas =
          client
              .apps()
              .deployments()
              .inNamespace(namespace)
              .withName(deployment)
              .get()
              .getStatus()
              .getReplicas();

      var newReplicas = replicas - count;
      var response =
          client
              .apps()
              .deployments()
              .inNamespace(namespace)
              .withName(deployment)
              .scale(newReplicas, true);

      if (response.getStatus().getReplicas().equals(newReplicas)) {
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
