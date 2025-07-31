# frozen_string_literal: true

module Soon
  ####          0       1      2      3       4
  LABELS = %w[Reading Soonest Sooner Default Someday].freeze

  def soon_label = LABELS.[](soon)

  def set_reading
    update soon: 0
    self
  end

  # after reading
  def reset_soon
    update soon: 3
    self
  end

  def move_soon_up
    return if parent.blank?

    Rails.logger.debug { "moving #{soon_label} to parent" }
    parent.update soon: soon
    reset_soon
    parent.move_soon_up
  end
end
