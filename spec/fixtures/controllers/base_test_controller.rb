# frozen_string_literal: true

class BaseTestController < ActionController::Base
  include ValidateParams::Validatable

  attr_reader :params

  def initialize(params)
    @params = params

    super()
  end

  def run_callbacks
    __callbacks[:process_action].map { |callback| send(callback.instance_variable_get("@key")) }.last
  end

  def action_name
    controller_action
  end

  private
    def render(result)
      result
    end
end
