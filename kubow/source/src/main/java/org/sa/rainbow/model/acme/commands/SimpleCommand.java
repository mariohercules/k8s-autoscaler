package org.sa.rainbow.model.acme.commands;

import org.acmestudio.acme.element.property.IAcmeProperty;
import org.acmestudio.acme.model.command.IAcmeCommand;
import org.sa.rainbow.model.acme.AcmeModelInstance;

import java.util.Collections;
import java.util.List;

/** @author Carlos Mendes (cmendesce@gmail.com) */
public class SimpleCommand extends KubeAcmeModelCommand<IAcmeProperty> {

  protected SimpleCommand(
      String commandName, AcmeModelInstance model, String target, String... parameters) {
    super(commandName, model, target, parameters);
  }

  @Override
  protected List<IAcmeCommand<?>> doConstructCommand() {
    return Collections.emptyList();
  }

  @Override
  public IAcmeProperty getResult() throws IllegalStateException {
    return null;
  }
}
