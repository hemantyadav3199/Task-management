class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def index
    tasks = current_user.tasks.paginate(page: params[:page], per_page: params[:per_page] || 10)
    render json: {
      tasks: ActiveModelSerializers::SerializableResource.new(tasks, each_serializer: TaskSerializer),
      meta: {
        current_page: tasks.current_page,
        total_pages: tasks.total_pages,
        total_entries: tasks.total_entries
      }
    }
  end

  def create
    task = current_user.tasks.new(task_params)

    if task.save
      render json: task, serializer: TaskSerializer, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @task, serializer: TaskSerializer
  end

  def update
    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end