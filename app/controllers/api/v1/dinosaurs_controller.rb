# frozen_string_literal: true

# app/controllers/api/v1/dinosaurs_controller.rb
class Api::V1::DinosaursController < ApplicationController
  before_action :set_dinosaur, only: %i[show update destroy]

  # GET /dinosaurs or GET /cages/:cage_id/dinosaurs
  def index
    if params[:expanded]
      @dinosaurs = Cage.find(params[:cage_id]).dinosaurs.expanded if params[:cage_id]
      @dinosaurs ||= Dinosaur.expanded.by_species(dinosaur_params[:species])
    else
      @dinosaurs = Cage.find(params[:cage_id]).dinosaurs if params[:cage_id]
      @dinosaurs ||= Dinosaur.by_species(dinosaur_params[:species]).all
    end
    render json: @dinosaurs
  end

  # GET /dinosaurs/1
  def show
    render json: @dinosaur
  end

  # POST /dinosaurs
  def create
    @dinosaur = Dinosaur.new(dinosaur_params)
    puts "Dinosaur params: #{dinosaur_params}"

    if @dinosaur.save
      render json: @dinosaur, status: :created
    else
      render json: @dinosaur.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dinosaurs/1
  def update
    if @dinosaur.update(dinosaur_params)
      render json: @dinosaur
    else
      render json: @dinosaur.errors, status: :unprocessable_entity
    end
  end

  def filter_by_species
    @dinosaurs = Cage.find(params[:cage_id]).dinosaurs.where(species_id: params[:species])
  end

  # DELETE /dinosaurs/1
  def destroy
    @dinosaur.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dinosaur
    @dinosaur = Dinosaur.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def dinosaur_params
    params.permit(:name, :species_id, :cage_id, :species, :expanded)
  end
end
