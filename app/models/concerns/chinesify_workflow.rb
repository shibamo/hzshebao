module ChinesifyWorkflow
	extend ActiveSupport::Concern

	#直接获取状态名对应的中文名
  def translate_workflow_state_name(all_state_names)
  	all_state_names[self.current_state.name]
  end

  #直接获取事件名对应的中文名
  def translate_workflow_event_name(event_name, all_event_names)
  	all_event_names[event_name]
  end
end
