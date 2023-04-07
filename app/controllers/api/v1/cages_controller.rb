# frozen_string_literal: true

# app/controllers/api/v1/cages_controller.rb
class Api::V1::CagesController < ApplicationController
  before_action :set_cage, only: %i[show update]

  # GET /cages
  def index
    @cages = if params[:expanded]
               Cage.by_status(cage_params[:power_status]).expanded
             else
               Cage.by_status(cage_params[:power_status]).all
             end
    render json: @cages
  end

  # GET /cages/1
  def show
    render json: @cage
  end

  # POST /cages
  def create
    @cage = Cage.new(cage_params)

    if @cage.save
      render json: @cage, status: :created
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cages/1
  def update
    if @cage.update(cage_params)
      render json: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cages/1
  def destroy
    @cages.destroy
  end

  def power_on
    @cage = Cage.find(params[:cage_id])
    if @cage.power_on
      render json: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  def power_off
    @cage = Cage.find(params[:cage_id])
    if @cage.power_off
      render json: @cage
    else
      render json: @cage.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cage
    @cage = Cage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cage_params
    params.permit(:name, :capacity, :power_status)
  end
end
