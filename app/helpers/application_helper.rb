# frozen_string_literal: true

module ApplicationHelper
  def boolean_to_string(boolean)
    return "Yes" if boolean

    "No"
  end
end
