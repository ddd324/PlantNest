//
//  README.md
//  PlantNest
//
//  Created by Djy on 12/09/2026.
//

# PlantNest

PlantNest is an iOS plant care app designed for beginner indoor plant owners. The app helps users keep track of plant care, understand watering needs, check plant health, and receive simple care guidance.

## Domain Context

Beginner plant owners may forget care routines, receive conflicting advice, or feel unsure about what their plants need. PlantNest is designed to make plant care easier to understand and help users feel more confident when caring for indoor plants.

## Key Features

- Add and manage indoor plants
- View watering and fertilising schedules
- Check whether a plant may need watering
- Record plant care activities
- View care history
- Check plant health using a question-based flow
- View plant care guidance
- Simulated plant identification with multiple candidates and confidence levels
- Confirm plant identification before adding a plant

## Architecture

PlantNest uses an MVVM architecture with a separate Use Case layer.

The main structure is:

View → ViewModel → Use Case → Repository / Domain Model

Use Cases are used for important plant care operations and business rules, including:

- AssessWateringNeedUseCase
- CheckPlantHealthUseCase
- ConfirmPlantIdentificationUseCase
- GenerateCareScheduleUseCase
- GetCarePlanUseCase
- RecordCareActivityUseCase

Repositories are used to separate data storage from the app's business logic.

## Testing

The project includes unit tests for the main Use Cases and other important functions, including successful cases, failure cases, and boundary conditions.
                                                    
Mock repositories are used in tests where appropriate so that the app's stored sample data is not modified during testing.

## Setup

1. Open the PlantNest project in Xcode.
2. Select an iPhone simulator.
3. Build and run the app.
4. No external API or account setup is required.

