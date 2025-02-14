using System;
using System.Linq;


namespace Project1Part2._1
{
    class Program 
    {
        public static void Main(string[] args)
        {
            int inputCount = 2; // study time and attendance
            int dataCount = 21; // the number of data sets

            Neuron neuron = new Neuron();

            double[] weights = Neuron.RandomizeWeight(inputCount);
            double[,] inputs = Neuron.UpdateInputs(neuron.inputs, dataCount);

            (double[] outputs, double[] updatedWeights) = Neuron.Train(dataCount, weights, inputs, 0.05, 10);
            //printing out the table returned from the Train() method
            Console.WriteLine("Input Values | Target Values | Predicted Values");
            Console.WriteLine("-----------------------------------------------");
            for (int i = 0; i < dataCount; i++)
            {
                Console.WriteLine($"{inputs[i, 0],-4:F2} | {inputs[i, 1],-5:F2} | {inputs[i, 2],-13:F2} | {outputs[i],-15:F2}");
            }
            Console.WriteLine();
            //prints out the MSE for the first values
            double MSE = Neuron.CalculateMSE(dataCount, weights, inputs, 0.05, 10);
            Console.WriteLine($"MSE Value: {MSE} (for epoch=10, learning rate = 0.0)");


            Console.WriteLine();
            Neuron.OutOfSamplePrediction(updatedWeights);
            Console.WriteLine();
            Neuron.TrainAndCalculateMSEWithDifferentValues(dataCount, weights, inputs);

            Console.ReadLine();
            Console.WriteLine();


        }


    }
    class Neuron
    {

        public double[,] inputs = new double[,]
        {
            { 7.6, 11, 77 }, { 8, 10, 70 }, { 6.6, 8, 55 }, { 8.4, 10, 78 }, { 8.8, 12, 95 }, { 7.2, 10, 67 },
            { 8.1, 11, 80 }, { 9.5, 9, 87 }, { 7.3, 9, 60 }, { 8.9, 11, 88 }, { 7.5, 11, 72 }, { 7.6, 9, 58 },
            { 7.9, 10, 70 }, { 8, 10, 76 }, { 7.2, 9, 58 }, { 8.8, 10, 81 }, { 7.6, 11, 74 }, { 7.5, 10, 67 },
            { 9, 10, 82 }, { 7.7, 9, 62 }, { 8.1, 11, 82 }
        };

        public static double[] RandomizeWeight(int inputCount) //creates two random weights for two inputs
        {
            Random random = new Random();
            double[] weights = new double[inputCount];

            for (int i = 0; i < inputCount; i++)
            {
                weights[i] = Math.Round(random.NextDouble(), 2);
            }
            return weights;

        }
        public static double[,] UpdateInputs(double[,] inputs, int dataCount) //updates the inputs according to the given factors
        {
            double StudyTimeFactor = 0.1;
            double AttendanceFactor = 0.066;
            double ExamResultFactor = 0.01;

            for (int j = 0; j < dataCount; j++)
            {
                inputs[j, 0] = inputs[j, 0] * StudyTimeFactor;
                inputs[j, 1] = inputs[j, 1] * AttendanceFactor;
                if (dataCount == 21) // OutOfSamplePrediction() and Train() are both using this method
                { inputs[j, 2] = inputs[j, 2] * ExamResultFactor; }

            }
            return inputs;

        }
        public static double[] CalculateOutput(int dataCount, double[] weights, double[,] inputs)
        {
            double[] outputs = new double[dataCount];
            for (int i = 0; i < dataCount; i++)
            {
                outputs[i] += weights[0] * inputs[i, 0] + weights[1] * inputs[i, 1];  // the sum formula for neuron model
            }
            return outputs;
        }

        public static (double[], double[]) Train(int dataCount, double[] weights, double[,] inputs, double LearningRate, int epoch)
        {
            double[] outputs = CalculateOutput(dataCount, weights, inputs);

            for (int i = 0; i < epoch; i++)
            {
                for (int j = 0; j < dataCount; j++)   //wi = wi + λ*(t-o)*xi  
                {
                    weights[0] = weights[0] + LearningRate * (inputs[j, 2] - outputs[j]) * inputs[j, 0];
                    weights[1] = weights[1] + LearningRate * (inputs[j, 2] - outputs[j]) * inputs[j, 1];
                }

                outputs = CalculateOutput(dataCount, weights, inputs);
            }

            return (outputs.ToArray(), weights);
        }

        public static double CalculateMSE(int dataCount, double[] weights, double[,] inputs, double LearningRate, int epoch )
        {
            (double[] outputs, double[] updatedWeights) = Train(dataCount, weights, inputs, LearningRate, epoch);
            double sum = 0;
            double MSE = 0;

            //MSE formula  = 1/n ( Σ(target − output)^2) 

            for (int i = 0; i < dataCount; i++) { sum += Math.Pow((inputs[i, 2] - outputs[i]), 2); }
            MSE = sum / dataCount;        
            return MSE;
        } 

        public static void OutOfSamplePrediction(double[] updatedWeights) //uses a different input sample 
        {
            double[,] inputSample = new double[,] { { 7.8, 10 }, { 8.5, 12 }, { 7.0, 8 }, { 9.2, 11 }, { 7.8, 9 } };
            inputSample = UpdateInputs(inputSample, 5);
            double[] outputs = CalculateOutput(5, updatedWeights, inputSample); 

            //printing out the table
            Console.WriteLine("Input Values | Predicted Values");
            Console.WriteLine("-------------------------------");
            for (int i = 0; i < 5; i++)
            {
                Console.WriteLine($"{inputSample[i, 0],-4:F2} | {inputSample[i, 1],-6:F2}| {outputs[i],-15:F2}");
            }
        }

        public static void TrainAndCalculateMSEWithDifferentValues(int dataCount, double[] weights, double[,] inputs)
        {
            
            double[] learningRateValues = { 0.01, 0.025, 0.05 };
            int[] epochValues = { 10, 50, 100 };
            double[,] resultsTable = new double[learningRateValues.Length, epochValues.Length];

            for (int i = 0; i < learningRateValues.Length; i++)
            {
                for (int j = 0; j < epochValues.Length; j++)
                {
                    resultsTable[i, j] = CalculateMSE(dataCount, weights, inputs, learningRateValues[j], epochValues[i]);
                }
            }

            // prints the headline
            Console.Write("Learning Rate\\Epoch    |");
            for (int j = 0; j < epochValues.Length; j++)
            {
                Console.Write($"{epochValues[j],-23}|");
            }
            Console.WriteLine();

            // prints the separator line
            Console.Write("-----------------------|");
            for (int j = 0; j < epochValues.Length; j++)
            {
                Console.Write("-----------------------|");
            }
            Console.WriteLine();

            // prints the results
            for (int i = 0; i < learningRateValues.Length; i++)
            {
                Console.Write($"{learningRateValues[i],-23}|");
                for (int j = 0; j < epochValues.Length; j++)
                {
                    Console.Write($"{resultsTable[i, j],-23:F14}|");
                }
                Console.WriteLine();

                // prints the separator line
                Console.Write("-----------------------|");
                for (int j = 0; j < epochValues.Length; j++)
                {
                    Console.Write("-----------------------|");
                }
                Console.WriteLine();
            }

        }
    }
}


