module AdminsBackofficeHelper
  def translate_attribute(object = nil, method = nil)
    (object && method) ? object.model.human_attribute_name(method) : "Informe corretamente os dados"
  end
end
