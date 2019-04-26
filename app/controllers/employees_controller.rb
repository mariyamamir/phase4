class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  
  def index
    @active_employees = Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def show
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(page: params[:page]).per_page(5)
    # get upcoming shifts for this employee (later)  
  end

  def new
    @employee = Employee.new
    @employee.build_user
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    
    if @employee.save
        respond_to do |format|
        format.html { redirect_to @employee, notice: "Successfully created #{@employee.proper_name}." }
        format.json { render :show, status: :created, location: @employee }
        end
      else
        render action: 'new'
      
    end
  end

  def update
   
      if @employee.update(employee_params)
        respond_to do |format|
          format.html { redirect_to @employee, notice: "Successfully updated #{@employee.proper_name}." }
          format.json { render :show, status: :ok, location: @store }
        end
      else
          format.html { render :edit }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    
    
  end

  def destroy
    # #FIXXXXXXXXXX
    @employee.destroy
    # # users are deleted automatically if the employee is deleted
    # @user.employee_id = @employee.id 
    # @user.destroy 
    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Successfully removed #{@employee.proper_name} from the AMC system." }
      format.json { head :no_content }
    end
    
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :date_of_birth, :role, :phone, :active)
  end

end