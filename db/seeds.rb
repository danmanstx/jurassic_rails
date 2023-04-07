# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
Species.destroy_all
Cage.destroy_all
Dinosaur.destroy_all

# seed species
Species.create!(name: 'Velociraptor', diet: :carnivore)
Species.create!(name: 'Tyrannosaurus', diet: :carnivore)
Species.create!(name: 'Brachiosaurus', diet: :herbivore)
Species.create!(name: 'Triceratops', diet: :herbivore)
Species.create!(name: 'Stegosaurus', diet: :herbivore)
Species.create!(name: 'Ankylosaurus', diet: :herbivore)
Species.create!(name: 'Spinosaurus', diet: :carnivore)
Species.create!(name: 'Megalosaurus', diet: :carnivore)

# Create some cages
Cage.create!(name: 'Cage 1', capacity: 10, power_status: :active)
Cage.create!(name: 'Cage 2', capacity: 8, power_status: :active)
Cage.create!(name: 'Cage 3', capacity: 5, power_status: :down)
Cage.create!(name: 'Cage 4', capacity: 12, power_status: :active)
Cage.create!(name: 'Cage 5', capacity: 6, power_status: :active)
Cage.create!(name: 'Cage 6', capacity: 2, power_status: :active)

# Create some dinosaurs
Dinosaur.create!(name: 'Bill', species_id: 1, cage_id: 1)
Dinosaur.create!(name: 'Leo', species_id: 2, cage_id: 2)
Dinosaur.create!(name: 'Steve', species_id: 1, cage_id: 1)
Dinosaur.create!(name: 'Bob', species_id: 2, cage_id: 2)
Dinosaur.create!(name: 'Brach', species_id: 3, cage_id: 4)
Dinosaur.create!(name: 'Tri', species_id: 4, cage_id: 5)
Dinosaur.create!(name: 'Mike', species_id: 3, cage_id: 4)
Dinosaur.create!(name: 'John', species_id: 4, cage_id: 5)
Dinosaur.create!(name: 'Brachy', species_id: 3, cage_id: 6)
Dinosaur.create!(name: 'Brachytwo', species_id: 3, cage_id: 6)

# Reset the counters
Cage.find_each { |cage| Cage.reset_counters(cage.id, :dinosaurs) }
