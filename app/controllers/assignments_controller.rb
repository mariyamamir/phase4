class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  # before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  def index
    @current_assignments = Assignment.current.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(15)
    @past_assignments = Assignment.past.by_employee.by_store.paginate(page: params[:page]).per_page(15)  
  end

   def show
  #   # get the shift history for this assignment (later; empty now)
   end

  def new
    @assignment = Assignment.new
    
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
     respond_to do |format|
      
        format.html { redirect_to @assignment, notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}." }
        format.json { render :index, status: :created, location: @assignment }
      end
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
    end
   
  end

  def update
    if @assignment.update(assignment_params) 
    respond_to do |format|
     
        format.html { redirect_to @assignment, notice: "#{@assignment.employee.proper_name}'s assignment to #{@assignment.store.name} is updated." }
        format.json { render :show, status: :ok, location: @assignment }
      end
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: "Successfully removed #{@assignment.employee.proper_name} from #{@assignment.store.name}." }
      format.json { head :no_content }
    end
    
  end

  private
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:employee_id, :store_id, :start_date, :end_date, :pay_level)
  end

  def page_params
    params.permit(:page)
  end
end