module CheckoutHelper
  def ckeckout_progress_bar
    content_tag(:ul, class: 'steps list-inline') do
      wizard_steps.enum_for(:each_with_index).collect do |ckeckout_step, index|
        class_str = 'step'
        class_str = 'step active' if ckeckout_step == step
        class_str = 'step done' if past_step?(ckeckout_step)
        concat(
          content_tag(:li, class: class_str) do
            concat(content_tag(:span, span_content(index, ckeckout_step), class: 'step-number'))
            concat(content_tag(:span, t(ckeckout_step), class: 'step-text hidden-xs'))
          end
        )
        concat(content_tag(:li, '', class: 'step-divider')) unless ckeckout_step == wizard_steps.last
      end
    end
  end

  def span_content(index, ckeckout_step)
    return index + 1 unless past_step?(ckeckout_step)
    content_tag(:i, '', class: 'fa fa-check step-icon')
  end
end