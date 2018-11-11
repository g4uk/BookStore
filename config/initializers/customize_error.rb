# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html = html_tag.html_safe

  form_fields = %w[
    textarea
    input
    select
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css 'label, ' + form_fields.join(', ')

  elements.each do |e|
    if e.node_name.eql? 'label'
      html = %(<div class="form-group has-error">#{e}</div>).html_safe
    elsif form_fields.include? e.node_name
      if instance.error_message.is_a?(Array)
        html = %(<div class="form-group has-error">#{html_tag}<span class="help-block">&nbsp;#{instance.error_message.uniq.join(', ')}</span></div>).html_safe
      else
        html = %(<div class="form-group has-error">#{html_tag}<span class="help-block">&nbsp;#{instance.error_message}</span></div>).html_safe
      end
    end
  end
  html
end
