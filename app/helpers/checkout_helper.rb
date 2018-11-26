# frozen_string_literal: true

module CheckoutHelper
  def ckeckout_progress_bar_span_content(index, ckeckout_step)
    return index + 1 unless past_step?(ckeckout_step)
    content_tag(:i, '', class: 'fa fa-check step-icon')
  end

  def step_class(current_step, ckeckout_step)
    return 'active' if ckeckout_step == current_step
    'done' if past_step?(ckeckout_step)
  end
end
