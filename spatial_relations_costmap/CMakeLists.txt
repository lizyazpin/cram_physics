cmake_minimum_required(VERSION 2.8.3)
project(spatial_relations_costmap)

find_package(catkin REQUIRED COMPONENTS
  #cram_roslisp_common
  cram_designators
  cram_location_costmap
  cram_semantic_map_costmap
  cram_bullet_reasoning
  cram_pr2_knowledge
  cram_environment_representation
  pr2_projection_process_modules
  cram_occupancy_grid_costmap
  #cram_plan_knowledge
  cram_occasions_events
  cram_bullet_reasoning_designators
  pr2_manipulation_knowledge
  cram_semantic_map_designators
)

#set the default path for built executables to the "bin" directory
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

catkin_package()

