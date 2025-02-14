using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;



class Program 
{

    static void Main(string[] args)
    {
        UH_Area uH_Area = new UH_Area();
        List<UH_Area> areasList = uH_Area.AddToList(@"C:\Users\yaren\Desktop\infotextfile.txt", @"C:\Users\yaren\Desktop\infotextfile2.txt");
        Tree tree = CreateBinaryTree(areasList); 


        //USER MENU
        int number = 0;
        while (number != 6)
        {
            Console.WriteLine("\n----------------------");
            Console.WriteLine("USER MENU");
            Console.WriteLine("----------------------");
            Console.WriteLine("1. Print All UNESCO Heritage Areas and Tree Information");
            Console.WriteLine("2. Print UNESCO Heritage Areas in Between Entered Letters");
            Console.WriteLine("3. Create Tree from Array by Middle Element");
            Console.WriteLine("4. Change Area Name in Hashtable");
            Console.WriteLine("5. Print The  First 3 Items Alphabetically from MinHeap");
            Console.WriteLine("6. Exit");
            Console.WriteLine("Enter your choice (1-6): ");

            if (int.TryParse(Console.ReadLine(), out number))
            {
                switch (number)
                {
                    case 1:
                        Console.WriteLine("UNESCO HERITAGE AREAS \n---------------------------");
                        PrintOutTreeInfo(tree, tree.getRoot());
                        break;

                    case 2:
                        Console.WriteLine("Enter the first letter: ");
                        char firstLetter = Console.ReadKey().KeyChar;
                        Console.WriteLine("\nEnter the second letter: ");
                        char secondLetter = Console.ReadKey().KeyChar;
                        Console.WriteLine($"UNESCO HERITAGE AREAS FROM {firstLetter} TO {secondLetter} \n-------------------------------------");
                        FindNodesInBetweenLetters(tree, firstLetter, secondLetter);
                        break;

                    case 3:
                        CreateTreeFromArray(tree);
                        Console.WriteLine("Balanced Tree created from Array.");
                        break;

                    case 4:
                        Console.WriteLine("Enter the key to change: ");
                        string enteredKey = Console.ReadLine();
                        Console.WriteLine("Enter the new key: ");
                        string newKey = Console.ReadLine();
                        Console.WriteLine("ELEMENTS OF THE HASHTABLE \n ------------------------------------");
                        Hashtable hashtable = AddToHashtable(areasList);
                        Console.WriteLine("Updated Area: \n");
                        ChangeAreaName(hashtable, enteredKey, newKey);
                        Console.WriteLine("Area name in Hashtable has changed.");
                        break;

                    case 5:
                        MinHeap minHeap = CreateMinHeap(areasList);
                        ListMinHeap(minHeap);
                        break;
                    case 6:
                        Console.WriteLine("Exiting the program.");
                        break;

                    default:
                        Console.WriteLine("Invalid choice. Please enter a number between 1 and 6.");
                        break;
                }
            }
            else
            {
                Console.WriteLine("Invalid input. Please enter a number.");
                Console.ReadLine(); 
            }
        }
    }  


    public static Tree CreateBinaryTree(List<UH_Area> areasList) //creates the binary tree by using insertion method
    {
        Tree tree = new Tree();
        foreach (var item in  areasList)
        {
            tree.insert(item);
        }
        return tree;
    }

    public static void PrintOutTreeInfo(Tree tree, TreeNode localRoot) //prints out the tree info (depth, node count, uhAreas)
    {
        int maxDepth = 0;
        int nodeCount = 0;
        int depth = Tree.TraverseNode(tree.getRoot(), 0, ref maxDepth, ref nodeCount);  //traverses the tree to calculate depth
        Console.WriteLine($"Tree Depth: {depth}");
        Console.WriteLine($"There are {nodeCount} nodes in this tree.");
        
        //formula for the depth of a balanced tree: log(n+1)base2 - 1
        double balancedDepth = Math.Log(nodeCount + 1, 2) - 1;
        Console.WriteLine($"Depth for the balanced tree: {(int)balancedDepth}");
        Console.WriteLine("");
        tree.inOrder(localRoot); //prints out the uhArea infos
    }

    public static void FindNodesInBetweenLetters(Tree tree, char letter1, char letter2)
    { 
        TreeNode firstNode = tree.getRoot(); //gets the first node of the tree to start the inorder method
        

        if (firstNode != null && (letter1 != ' ' && letter2 != ' ')) //checks if there are any letters entered to the inorder method
        {
            tree.inOrder(firstNode, letter1, letter2);
        }
        else if (firstNode != null)
        {
            tree.inOrder(firstNode);
        }
        else
        {
            Console.WriteLine("Given letters are not in the tree.");
        }
    }

    public static UH_Area[] TreeToArray(TreeNode root) //creates a sorted array from the tree
    {
        int count = 21;
        UH_Area[] sortedArray = new UH_Area[count];
        int index = 0;
        InOrderTraversal(root, ref index, sortedArray);
        return sortedArray;
    }
    private static void InOrderTraversal(TreeNode node, ref int index, UH_Area[] areasArray) //a traversal method for TreeToArray
    {
        if (node != null)
        {
            InOrderTraversal(node.leftChild, ref index, areasArray); 
            areasArray[index++] = node.data;
            InOrderTraversal(node.rightChild, ref index, areasArray);
        }
    }
    public static void CreateTreeFromArray(Tree tree) //creates a binary tree from the sorted array by using middle index
    {
        UH_Area[] sortedArray = TreeToArray(tree.getRoot());
        Tree newTree = new Tree();

        // inserts middle element as the root of the tree
        newTree.insert(sortedArray[sortedArray.Length / 2]);

        // adds the left and right nodes to the tree
        newTree.getRoot().leftChild = AddElementToNewTree(sortedArray, 0, sortedArray.Length / 2 - 1);
        newTree.getRoot().rightChild = AddElementToNewTree(sortedArray, sortedArray.Length / 2 + 1, sortedArray.Length - 1);
        TreeNode node = newTree.getRoot();
        tree.inOrder(node.leftChild);
        node.displayNode();
        tree.inOrder(node.rightChild);
    }
    public static TreeNode AddElementToNewTree(UH_Area[] sortedArray, int start, int end)
    {
        if (start > end)
        {
            return null;
        }

        int middleIndex = (start + end) / 2;

        // creates the root from the middle element
        TreeNode root = new TreeNode();
        root.data = sortedArray[middleIndex];

        root.leftChild = AddElementToNewTree(sortedArray, start, middleIndex - 1);
        root.rightChild = AddElementToNewTree(sortedArray, middleIndex + 1, end);

        return root;
    }

    public static Hashtable AddToHashtable(List<UH_Area> areasList) //adds the uhArea elements to a hashtable
    {
        Hashtable hashtable = new Hashtable();
        foreach (var value in areasList)
        {
            string key = value.areaName.Trim();
            hashtable.Add(key, value);
        }

        foreach (DictionaryEntry value in hashtable)
        {
            UH_Area node = (UH_Area)value.Value;
            Console.WriteLine(node.ToString());
        }
        return hashtable;
    }
    public static void ChangeAreaName(Hashtable hashtable, string enteredKey, string newKey) //changes the key and the areaName of the node
    {
        UH_Area uhArea = (UH_Area)hashtable[enteredKey];
        hashtable.Remove(enteredKey);
        uhArea.areaName = newKey;
        hashtable.Add(newKey, uhArea);
        Console.WriteLine(uhArea.ToString());

    }


    public static MinHeap CreateMinHeap(List<UH_Area> areasList)
    { //creates the minHeap array and prints out the first 3 nodes
        MinHeap minHeap = new MinHeap();
        foreach (var node in areasList)
        {
            minHeap.Insert(node);
        }
        return minHeap;
    }

    public static void ListMinHeap(MinHeap minHeap)
    {
        for (int i = 0; i < 3; i++)
        {
            UH_Area minUH_Area = minHeap.Remove();
            Console.Write($"Area Name: {minUH_Area.areaName} \nCities: {string.Join(", ", minUH_Area.cityNames)} \nPublication Year: {minUH_Area.publicationYear}");
            Console.WriteLine("");
            Console.WriteLine($"Area Info: {string.Join(" ", minUH_Area.areaInfo)}");
            Console.WriteLine("");
            Console.WriteLine("");
        }
    }

}

public class UH_Area //unesco heritage areas class
{
    public string areaName { get; set; }
    public List<string> cityNames { get; set; }
    public int publicationYear { get; set; }

    public List<string> areaInfo { get; set; }

    public List<UH_Area> areasList = new List<UH_Area>(21);


    //constructor methods
    public UH_Area() { }

    public UH_Area(string areaName, List<string> cityNames, int publicationYear, List<string> areaInfo)
    {
        this.areaName = areaName;
        this.cityNames = cityNames;
        this.publicationYear = publicationYear;
        this.areaInfo = new List<string>();
        this.areaInfo.AddRange(areaInfo);
    }

    //methods
    public List<UH_Area> AddToList(string filePath1, string filePath2) //adds the information read from files to lists
    {
        //reading the lines from file
        string[] lines1 = File.ReadAllLines(filePath1); 
        string[] lines2 = File.ReadAllLines(filePath2);

        int iterations = Math.Max(lines1.Length, lines2.Length);
        for (int i = 0; i < iterations; i++)
        {
            string line1 = (i < lines1.Length) ? lines1[i] : "";
            string line2 = (i < lines2.Length) ? lines2[i] : "";

            if (!string.IsNullOrEmpty(line1))
            {
                List<string> cityNames = new List<string>();
                string[] parts = new string[3];
                parts[0] = line1.Split('(', ')')[0]; // area name
                parts[1] = line1.Split('(', ')')[1]; // info inside the parentheses
                parts[2] = line1.Split('(', ')')[2]; // publication year

                string areaName = parts[0];
                if (parts[1].Contains(","))
                {
                    string insideParentheses = parts[1];
                    string[] insideParenthesesArray = insideParentheses.Split(',');
                    foreach (string part in insideParenthesesArray)
                    {
                        // get the city name before the hyphen
                        part.Trim();
                        int separatorIndex = part.IndexOf('-');
                        cityNames.Add(part.Substring(0, separatorIndex).Trim());
                    }
                }
                else { cityNames = new List<string>(parts[1].Split('-')); }

                int publicationYear = int.Parse(parts[2].Trim());

                if (!string.IsNullOrEmpty(line2))
                {
                    List<string> areaInfoList = new List<string>();
                    areaInfoList.AddRange(line2.Trim().Split(' '));
                    UH_Area uhArea = new UH_Area(areaName, cityNames, publicationYear, areaInfoList);
                    areasList.Add(uhArea);
                }
                
            }

        }
        return areasList;
    }

    public override string ToString()
    {
        // Create a string representation of the object
        return $"Area Name: {areaName} \nCities: {string.Join(", ", cityNames)} \nPublication Year: {publicationYear} \nArea Info: {string.Join(" ", areaInfo)} \n";
    }
}

// node class
class TreeNode
{
    public UH_Area data;
    public TreeNode leftChild;
    public TreeNode rightChild;

    //constructor methods
    public TreeNode () { }
    public TreeNode(UH_Area key)
    {
        data = key;
    }

    public UH_Area GetKey()
    {
        return data;
    }

    public void SetKey(UH_Area key)
    {
        data = key;
    }
    public void displayNode() // to string method for the nodes
        { 
        Console.Write($"Area Name: {data.areaName} \nCities: {string.Join(", ", data.cityNames)} \nPublication Year: {data.publicationYear}");
        Console.WriteLine("");
        Console.WriteLine($"Area Info: {string.Join(" ", data.areaInfo)}");
        Console.WriteLine("");
        Console.WriteLine("");
    }
}

// tree class
class Tree
{
    private TreeNode root;
    public Tree() { root = null; }

    public TreeNode getRoot()
    { return root; }

    // preorder traversal 
    public void preOrder(TreeNode localRoot)
    {
        if (localRoot != null)
        {
            localRoot.displayNode();
            preOrder(localRoot.leftChild);
            preOrder(localRoot.rightChild);
        }
    }

    // inorder traversal 
    // used for 2 different methods
    public void inOrder(TreeNode node, char letter1 = 'A', char letter2 = 'Z')
    {
        if (node != null)
        {
            inOrder(node.leftChild, letter1, letter2);

            string areaName = node.data.areaName.ToUpper();

            if (CompareChars(areaName[0], char.ToUpper(letter1)) >= 0 &&
                CompareChars(areaName[0], char.ToUpper(letter2)) <= 0)
            {
                node.displayNode();
            }

            inOrder(node.rightChild, letter1, letter2);
        }
    }

    // for area names that start with Turkish letters (İstanbul, Çatalhöyük)
    private int CompareChars(char char1, char char2)
    {
        return string.Compare(char1.ToString(), char2.ToString(), StringComparison.CurrentCulture);
    }


    // postorder traversal
    public void postOrder(TreeNode localRoot)
    {
        if (localRoot != null)
        {
            postOrder(localRoot.leftChild);
            postOrder(localRoot.rightChild);
            localRoot.displayNode();
        }
    }

    // adds a node to tree
    public void insert(UH_Area newdata) 
    {
        TreeNode newNode = new TreeNode();
        newNode.data = newdata;
        if (root == null)
            root = newNode;
        else
        {
            TreeNode current = root;
            TreeNode parent;
            while (true)
            {
                parent = current;
                if (newdata.areaName.CompareTo(current.data.areaName) < 0)
                {
                    current = current.leftChild;
                    if (current == null)
                    {
                        parent.leftChild = newNode;
                        return;
                    }
                }
                else 
                {
                    current = current.rightChild;
                    if (current == null)
                    {
                        parent.rightChild = newNode;
                        return;
                    }
                }
            }
        }
    }
    
    public static int TraverseNode(TreeNode node, int depth, ref int maxDepth, ref int nodeCount)
    {
        if (node == null) return maxDepth; 

        // increments the node count
        nodeCount++;

        // updates the max depth if needed
        if (depth > maxDepth)
        {
            maxDepth = depth;
        }
        TraverseNode(node.leftChild, depth + 1, ref maxDepth, ref nodeCount);
        TraverseNode(node.rightChild, depth + 1, ref maxDepth, ref nodeCount);

        return maxDepth;
    }

}

//min heap class
class MinHeap
{
    private List<UH_Area> heapArray;
    private int heapSize;

    // constructor method
    public MinHeap()
    {
        heapArray = new List<UH_Area>();
        heapSize = 0;
    }

    public bool IsEmpty() { return heapSize == 0; }

    public void Insert(UH_Area node)
    {
        heapArray.Add(node);
        heapSize++;
        TrickleUp(heapSize - 1);
    }

    public int CompareNodes(UH_Area node1, UH_Area node2)
    {
        return string.Compare(node1.areaName, node2.areaName, CultureInfo.InvariantCulture, CompareOptions.IgnoreCase);
    }


    public void TrickleDown(int index) // (heapify down) for remove() method
    {
        int smallChild;
        while (index < heapSize / 2)
        {
            int leftChild = index * 2 + 1;
            int rightChild = index * 2 + 2;

            if (rightChild < heapSize && CompareNodes(heapArray[leftChild], heapArray[rightChild]) > 0)
            {
                smallChild = rightChild;
            }
            else
            {
                smallChild = leftChild;
            }

            if (CompareNodes(heapArray[index], heapArray[smallChild]) <= 0)
            {
                break;
            }

            Swap(index, smallChild);
            index = smallChild;
        }
    }

    private void TrickleUp(int index)  // (heapify up) for insert() method
    {
        int parent = (index - 1) / 2;

        while (index > 0 && CompareNodes(heapArray[parent], heapArray[index]) > 0)
        {
            Swap(index, parent);
            index = parent;
            parent = (index - 1) / 2;
        }
    }

    public UH_Area Remove()
    {
        if (heapSize == 0)
        {
            throw new InvalidOperationException("Heap is empty.");
        }

        UH_Area root = heapArray[0];
        heapArray[0] = heapArray[heapSize - 1];
        heapSize--;
        TrickleDown(0);

        return root;
    }

    private void Swap(int i, int j) //for trickleUp and trickleDown methods
    {
        UH_Area temp = heapArray[i];
        heapArray[i] = heapArray[j];
        heapArray[j] = temp;
    }
}


