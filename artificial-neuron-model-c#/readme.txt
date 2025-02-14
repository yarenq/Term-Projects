This project implements a perceptron-based artificial neuron model to predict student exam scores based on study time and class attendance using supervised learning techniques.

Features
Neuron Model Implementation
Develops a Neuron class to handle inputs, weights, and computations.
Initializes weights randomly within the range [0,1].
Model Training
Uses a dataset linking study hours and attendance to exam scores.
Trains the model using a learning rate (λ = 0.05) for 10 epochs.
Updates weights using supervised learning rules.
Prediction and Performance Evaluation
Predicts exam scores using trained weights.
Calculates Mean Square Error (MSE) to evaluate model accuracy.
Extended Training Experiments
Runs additional training sessions with varying epochs (10, 50, 100) and learning rates (0.01, 0.025, 0.05).
Records MSE values and analyzes performance trends.
Generalization on New Data
Tests the trained model on new, unseen data points.
Reports predictions alongside actual expected results.
