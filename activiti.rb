require "jbundler"

Bundler.require "activiti-engine"
Bundler.require "h2"

require 'target/my-app-1.1-SNAPSHOT.jar'

class Runner
  def initialize
    @process_engine_configuration = Java::OrgActivitiEngine::ProcessEngineConfiguration.createProcessEngineConfigurationFromResource("activiti.cfg.xml")
    @process_engine = @process_engine_configuration.buildProcessEngine
    @repositoryService = @process_engine.getRepositoryService()
    @repositoryService.createDeployment().
      # without listener - works
      #addClasspathResource("org/activiti/test/VacationRequest.bpmn20.xml").
      # with listener - works kind of
      addClasspathResource("org/activiti/test/VacationRequestWithListener.bpmn20.xml").
      deploy()
  end

  def run
    puts "Number of process definitions: #{@repositoryService.createProcessDefinitionQuery().count()}"

    variables = {
      'employeeName' => "Kermit",
      'numberOfDays' =>  4,
      'vacationMotivation' => "I'm really tired!"
    }

    runtime_service = @process_engine.getRuntimeService();
    process_instance = runtime_service.startProcessInstanceByKey("vacationRequest", variables);
          
    puts "Number of process instances: #{runtime_service.createProcessInstanceQuery().count()}"
                
    task_service = @process_engine.getTaskService();
    tasks = task_service.createTaskQuery().taskCandidateGroup("management").list();
    tasks.each do |task|
      puts "task available: #{task.getName}"
    end

    task = tasks.first
          
    task_variables = {
      "vacationApproved" => "false",
      "managerMotivation" => "We have a tight deadline!"
    }
    task_service.complete(task.getId, task_variables);            

    puts "vacation request denied"

    puts "kermit's tasks"
    tasks = task_service.createTaskQuery().taskAssignee("Kermit").list();
    tasks.each do |task|
      puts "task available: #{task.getName}"
    end
  end
end

Runner.new.run

=begin
$process_engine_configuration = Java::OrgActivitiEngine::ProcessEngineConfiguration.createStandaloneInMemProcessEngineConfiguration
$process_engine = $process_engine_configuration.
  setDatabaseSchemaUpdate(Java::OrgActivitiEngine::ProcessEngineConfiguration::DB_SCHEMA_UPDATE_FALSE).
  setJdbcUrl("jdbc:h2:mem:my-own-db;DB_CLOSE_DELAY=1000").
  setJobExecutorActivate(true).
  buildProcessEngine
=end
