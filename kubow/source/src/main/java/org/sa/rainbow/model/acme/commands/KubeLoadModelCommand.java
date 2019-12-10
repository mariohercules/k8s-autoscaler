package org.sa.rainbow.model.acme.commands;

import org.acmestudio.acme.core.exception.AcmeException;
import org.acmestudio.acme.core.resource.IAcmeResource;
import org.acmestudio.acme.core.resource.ParsingFailureException;
import org.acmestudio.acme.core.type.IAcmeStringValue;
import org.acmestudio.acme.element.AbstractAcmeElementVisitor;
import org.acmestudio.acme.element.IAcmeSystem;
import org.acmestudio.acme.element.property.IAcmeProperty;
import org.acmestudio.acme.model.command.IAcmeCommand;
import org.acmestudio.acme.model.command.IAcmePropertyCommand;
import org.acmestudio.acme.model.util.core.UMStringValue;
import org.acmestudio.standalone.resource.StandaloneResourceProvider;
import org.sa.rainbow.core.error.RainbowException;
import org.sa.rainbow.core.models.IModelInstance;
import org.sa.rainbow.core.models.IModelsManager;
import org.sa.rainbow.core.models.ModelReference;
import org.sa.rainbow.core.models.commands.AbstractLoadModelCmd;
import org.sa.rainbow.model.acme.KubeModelUpdateOperatorsImpl;
import org.sa.rainbow.util.Util;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;

public class KubeLoadModelCommand extends AbstractLoadModelCmd<IAcmeSystem> {

  private String m_systemName;
  private KubeModelUpdateOperatorsImpl m_result;

  public KubeLoadModelCommand(String systemName, IModelsManager mm, InputStream is, String source) {
    super("loadKubeModel", mm, systemName, is, source);
    m_systemName = systemName;
  }

  @Override
  public ModelReference getModelReference() {
    return new ModelReference(m_systemName, "Acme");
  }

  @Override
  protected void subExecute() throws RainbowException {
    try {
      IAcmeResource resource =
          StandaloneResourceProvider.instance()
              .acmeResourceForObject(new File(getOriginalSource()));
      m_result =
          new KubeModelUpdateOperatorsImpl(
              resource.getModel().getSystem(m_systemName), getOriginalSource());

      // Do property substitution
      try {
        AcmePropertySubstitutionVisitor visitor = new AcmePropertySubstitutionVisitor();
        m_result.getModelInstance().visit(visitor, null);
        IAcmeCommand cmd = visitor.getCommand();
        if (cmd != null) {
          cmd.execute();
        }
      } catch (IllegalStateException | AcmeException e) {
        e.printStackTrace();
      }

      doPostExecute();
    } catch (ParsingFailureException | IOException e) {
      throw new RainbowException(e);
    }
  }

  @Override
  protected void subRedo() throws RainbowException {
    doPostExecute();
  }

  @Override
  protected void subUndo() throws RainbowException {
    doPostUndo();
  }

  @Override
  public IModelInstance<IAcmeSystem> getResult() {
    return m_result;
  }

  @Override
  public String getName() {
    return "LoadKubeModel";
  }

  @Override
  protected boolean checkModelValidForCommand(Object model) {
    return true;
  }

  public class AcmePropertySubstitutionVisitor extends AbstractAcmeElementVisitor {

    protected List<IAcmeCommand<?>> m_commands = new LinkedList<>();

    public IAcmeCommand getCommand() {
      if (m_commands.isEmpty()) return null;
      if (m_commands.size() == 1) return m_commands.get(0);
      return m_commands.get(0).getCommandFactory().compoundCommand(m_commands);
    }

    @Override
    public Object visitIAcmeProperty(IAcmeProperty property, Object data) {
      if (property.getValue() instanceof IAcmeStringValue) {
        IAcmeStringValue val = (IAcmeStringValue) property.getValue();
        String origVal = val.getValue();
        String newVal = Util.evalTokens(origVal);
        if (!newVal.equals(origVal)) {
          IAcmePropertyCommand cmd =
              property
                  .getCommandFactory()
                  .propertyValueSetCommand(property, new UMStringValue(newVal));
          m_commands.add(cmd);
        }
      }
      return data;
    }
  }
}
