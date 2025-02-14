using OfficeOpenXml;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using LicenseContext = OfficeOpenXml.LicenseContext;

class Program
{
    static void Main(string[] args)
    {

        ArrayList cities = new ArrayList
        {
            "x", "Adana", "Adıyaman", "Afyonkarahisar",
            "Ağrı", "Amasya", "Ankara",
            "Antalya", "Artvin", "Aydın",
            "Balıkesir", "Bilecik", "Bingöl",
            "Bitlis", "Bolu", "Burdur",
            "Bursa", "Çanakkale", "Çankırı",
            "Çorum", "Denizli", "Diyarbakır",
            "Edirne", "Elazığ", "Erzincan",
            "Erzurum", "Eskişehir", "Gaziantep",
            "Giresun", "Gümüşhane", "Hakkâri",
            "Hatay", "Isparta", "Mersin",
            "İstanbul", "İzmir", "Kars",
            "Kastamonu", "Kayseri", "Kırklareli",
            "Kırşehir", "Kocaeli", "Konya",
            "Kütahya", "Malatya", "Manisa",
            "Kahramanmaraş", "Mardin", "Muğla",
            "Muş", "Nevşehir", "Niğde",
            "Ordu", "Rize", "Sakarya",
            "Samsun", "Siirt", "Sinop",
            "Sivas", "Tekirdağ", "Tokat",
            "Trabzon", "Tunceli", "Şanlıurfa",
            "Uşak", "Van", "Yozgat",
            "Zonguldak", "Aksaray", "Bayburt",
            "Karaman", "Kırıkkale", "Batman",
            "Şırnak", "Bartın", "Ardahan",
            "Iğdır", "Yalova", "Karabük",
            "Kilis", "Osmaniye", "Düzce"
        };

        int[][] jaggedArray = CreateMatrix();
        int[][] sqArray = CreateSquareMatrix(@"C:\Users\lenovo\Downloads\distanceInfo.xlsx");
        //MENU

        Console.WriteLine("MENU");
        Console.WriteLine("----------------------------------");
        Console.WriteLine("1) List the cities within a certain distance from the given city and their distances.");
        Console.WriteLine("2) Find the closest and farthest two cities in Turkey.");
        Console.WriteLine("3) Determine the maximum number of cities that can be visited from the given city using a given distance.");
        Console.WriteLine("4) Display the distances between randomly selected 5 cities with different license plate numbers in matrix form.");
        Console.WriteLine("5) EXIT PROGRAM.");
        Console.WriteLine("");
        int number = 0;
        while (number != 5)
        {
            Console.WriteLine("Please enter a number between 1 and 5: ");
            int.TryParse(Console.ReadLine(), out number);
            switch (number)
            {
                case 1:
                    int distance;
                    Console.WriteLine("Enter a city name: ");
                    string city = Console.ReadLine();
                    city = char.ToUpper(city[0]) + city.Substring(1);
                    Console.WriteLine("Enter a distance: ");
                    int.TryParse(Console.ReadLine(), out distance);
                    (ArrayList validcities, ArrayList validcitiesDistance) = ListCitiesInGivenDistance(jaggedArray, city, distance, cities);
                    for (int i = 0; i < validcities.Count; i++)
                    {
                        Console.Write($"{validcities[i]}: {validcitiesDistance[i]} || ");
                    }
                    Console.WriteLine();
                    break;
                case 2:
                    MaxMinDistance(jaggedArray, cities);
                    break;
                case 3:

                    Console.WriteLine("Enter a city name: ");
                    city = Console.ReadLine();
                    city = char.ToUpper(city[0]) + city.Substring(1);
                    Console.WriteLine("Enter a distance: ");
                    int.TryParse(Console.ReadLine(), out distance);
                    FindMaxCityCount(sqArray, cities, city, distance);
                    break;
                case 4:
                    RandomCities(sqArray, cities);
                    break;
                case 5:
                    Console.WriteLine("Exiting program. Baiiii!");
                    break;
                default:
                    Console.WriteLine("Invalid input.");
                    break;
            }
        }



    }

    static int[][] CreateMatrix()
    {

        string excelFilePath = @"C:\Users\lenovo\Downloads\ilmesafe.xlsx";

        FileInfo fileInfo = new FileInfo(excelFilePath);
        ExcelPackage.LicenseContext = LicenseContext.NonCommercial;
        using (ExcelPackage package = new ExcelPackage(fileInfo))
        {
            var worksheet = package.Workbook.Worksheets[0];

            int startRow = 4;  // row index for the start cell
            int startColumn = 3;  // column index for the start cell 

            int endRow = 83;  // row index for the end cell
            int endColumn = 82;  // column index for the end cell 

            // gets the number of rows and columns in the diagonal
            int diagonalRowCount = endRow - startRow + 1;
            int diagonalColumnCount = endColumn - startColumn + 1;

            int[][] diagonalData = new int[diagonalRowCount][];

            for (int i = 0; i < diagonalRowCount; i++)
            {
                diagonalData[i] = new int[i + 1];
                for (int j = 0; j <= i; j++)
                {
                    var cellValue = worksheet.Cells[startRow + i, startColumn + j].Value;
                    if (int.TryParse(cellValue?.ToString(), out int distance))
                    {
                        diagonalData[i][j] = distance;
                    }
                    else
                    {
                        // if the cell value is not an integer, it sets it to 0
                        diagonalData[i][j] = 0;
                    }
                }
            }
            return diagonalData;

        }
    }
    static int[][] CreateSquareMatrix(string filePath)
    {
        FileInfo fileInfo = new FileInfo(filePath);

        using (ExcelPackage package = new ExcelPackage(fileInfo))
        {
            ExcelWorksheet worksheet = package.Workbook.Worksheets[0];

            int rowCount = worksheet.Dimension.Rows;
            int colCount = worksheet.Dimension.Columns;

            // Adjust the size of the squareArray to exclude the first two rows and columns
            int[][] squareArray = new int[rowCount - 2][];

            for (int i = 3; i <= rowCount; i++) // Start from the 3rd row
            {
                squareArray[i - 3] = new int[colCount - 2];

                for (int j = 3; j <= colCount; j++) // Start from the 3rd column
                {
                    var cellValue = worksheet.Cells[i, j].Value;

                    if (cellValue != null)
                    {
                        int parsedValue;
                        if (int.TryParse(cellValue.ToString(), out parsedValue))
                        {
                            squareArray[i - 3][j - 3] = parsedValue;
                        }
                        else
                        {
                            Console.WriteLine($"Error parsing cell value at row {i}, column {j}");
                            // Handle the error or set a default value as needed
                        }
                    }
                    else
                    {
                        // Handle the case where the cell is empty
                    }
                }
            }

            // Display the modified matrix
            //for (int k = 0; k < squareArray.Length; k++)
            //{
            //    for (int l = 0; l < squareArray[k].Length; l++)
            //    {
            //        Console.Write(squareArray[k][l] + "\t");
            //    }
            //    Console.WriteLine();
            //}
            //Console.ReadLine();
            return squareArray;
        }
    }

    public static (ArrayList, ArrayList) ListCitiesInGivenDistance(int[][] jaggedArray, string givenCity, int givenDistance, ArrayList cities)
    {


        ArrayList validCities = new ArrayList();
        ArrayList validCitiesDistance = new ArrayList();
        for (int i = 0; i < jaggedArray.Length; i++)
        {
            if (i + 2 == cities.IndexOf(givenCity)) //search the given city
            {
                for (int j = 0; j < jaggedArray[i].Length; j++) // iterates through horizontally
                {
                    if (jaggedArray[i][j] <= givenDistance)
                    {
                        validCities.Add(cities[j + 1]);
                        validCitiesDistance.Add(jaggedArray[i][j]);
                    }
                }

            }
            // iterates through diagonally
            if (i + 2 > cities.IndexOf(givenCity) && jaggedArray[i][cities.IndexOf(givenCity) - 1] <= givenDistance)
            {
                validCities.Add(cities[i + 2]);
                validCitiesDistance.Add(jaggedArray[i][cities.IndexOf(givenCity) - 1]);
            }

        }
        return (validCities, validCitiesDistance);

    }
    public static void MaxMinDistance(int[][] jaggedArray, ArrayList cities)
    {
        //creating the city objects
        object city1 = null;
        object city2 = null;
        object city3 = null;
        object city4 = null;

        int maxDistance = 0;
        int minDistance = 3000;
        for (int i = 0; i < jaggedArray.Length; i++) //iterates through the jaggedArray to check the distances between cities
        {
            for (int j = 0; j < i + 1; j++)
            {
                int distance = jaggedArray[i][j];
                if (distance > maxDistance) // updates the max distance
                {
                    maxDistance = distance;
                    city1 = (string)cities[i + 2];
                    city2 = (string)cities[j + 1];

                }
                else if (distance < minDistance) // updates the min distance
                {
                    minDistance = distance;
                    city3 = (string)cities[i + 2];
                    city4 = (string)cities[j + 1];
                }

            }
        }
        //prints out the results
        Console.WriteLine($"Max distance: {city1} - {city2} => {maxDistance}km");
        Console.WriteLine($"Min distance: {city3} - {city4} => {minDistance}km");

    }
    public static void RandomCities(int[][] sqArray, ArrayList cities)
    {
        int[] BubbleSort(int[] arr)
        {
            int n = arr.Length;
            for (int i = 0; i < n - 1; i++)
            {
                for (int j = 0; j < n - i - 1; j++)
                {
                    if (arr[j] > arr[j + 1])
                    {
                        // swap arr[j] and arr[j+1]
                        int temp = arr[j];
                        arr[j] = arr[j + 1];
                        arr[j + 1] = temp;
                    }
                }
            }
            return arr;
        }


        Random rnd = new Random();
        int[] citiesSelected = new int[5] { 0, 0, 0, 0, 0 };
        int counter = 0;

        while (citiesSelected[4] == 0)
        {
            int plateNumber = rnd.Next(1, 82);
            if (!citiesSelected.Contains(plateNumber)) { citiesSelected[counter] = plateNumber; counter++; }

        }
        citiesSelected = BubbleSort(citiesSelected); //sorts out the cities


        //prints out the city names and distances in a matrix form
        Console.WriteLine("+------------------------------------------------------------------------------+");
        Console.Write("|             ");
        for (int i = 0; i < 5; i++)
        {
            Console.Write($"| {cities[citiesSelected[i]],-11}");
        }
        Console.WriteLine("|");
        Console.WriteLine("+------------------------------------------------------------------------------+");

        for (int i = 0; i < 5; i++)
        {
            Console.Write($"| {cities[citiesSelected[i]],-12}");
            for (int j = 0; j < 5; j++)
            {
                if (citiesSelected[i] != citiesSelected[j] && citiesSelected[i] <= sqArray.Length && citiesSelected[j] <= sqArray.Length)
                {
                    Console.Write($"| {sqArray[citiesSelected[i] - 1][citiesSelected[j] - 1],-10} ");
                }
                else
                {
                    Console.Write("|  0         ");
                }
            }
            Console.WriteLine("|");
            Console.WriteLine("+------------------------------------------------------------------------------+");
        }

    }
    public static void FindMaxCityCount(int[][] sqArray, ArrayList cities, string startCity, int maxDistance)
    {
        // creates route lists
        List<List<string>> allRoutes = new List<List<string>>();
        List<string> currentRoute = new List<string>();

        // finds all possible routes
        FindAllRoutes(sqArray, cities, startCity, maxDistance, currentRoute, allRoutes);

        List<string> mostCitiesRoute = null;
        int maxCityCount = 0;

        // finds the route with the maximum number of cities visited
        foreach (var route in allRoutes)
        {
            if (route.Count > maxCityCount)
            {
                maxCityCount = route.Count;
                mostCitiesRoute = route;
            }
        }

        // displays the information
        if (mostCitiesRoute != null)
        {
            Console.WriteLine($"The route with the most cities visited: {string.Join(" -> ", mostCitiesRoute)}");
            Console.WriteLine($"Total city count: {mostCitiesRoute.Count}");
            Console.WriteLine("Distances:");

            int totalDistance = 0;
            for (int i = 0; i < mostCitiesRoute.Count - 1; i++)
            {
                int cityIndex1 = cities.IndexOf(mostCitiesRoute[i]) - 1;
                int cityIndex2 = cities.IndexOf(mostCitiesRoute[i + 1]) - 1;

                int distance = sqArray[cityIndex1][cityIndex2];
                totalDistance += distance;

                Console.WriteLine($"{mostCitiesRoute[i]} - {mostCitiesRoute[i + 1]}: {distance}km");
            }

            Console.WriteLine($"Total Distance: {totalDistance}km");
        }
        else
        {
            Console.WriteLine($"The city visited within the specified distance was not found.");
        }
    }

    private static void FindAllRoutes(int[][] sqArray, ArrayList cities, string currentCity, int remainingDistance,
                                      List<string> currentRoute, List<List<string>> allRoutes)
    {
        if (remainingDistance < 0)
        {
            return;
        }

        currentRoute.Add(currentCity);

        int currentIndex = cities.IndexOf(currentCity) - 1;

        // searches thruogh the neighbour cities to find possible routes within distance
        for (int i = 0; i < sqArray[currentIndex].Length; i++)
        {
            if (sqArray[currentIndex][i] > 0)
            {
                string nextCity = (string)cities[i + 1];
                int nextDistance = sqArray[currentIndex][i];

                if (!currentRoute.Contains(nextCity))
                {
                    // uses recursion to complete the route
                    FindAllRoutes(sqArray, cities, nextCity, remainingDistance - nextDistance, currentRoute, allRoutes);
                }
            }
        }

        // adds the routes to list when there is no city left to visit
        if (currentRoute.Count > 1)
        {
            allRoutes.Add(new List<string>(currentRoute));
        }

        currentRoute.RemoveAt(currentRoute.Count - 1);
    }



}
