using System;
using System.Linq;

namespace ConsoleApp2
{
    class Program
    {
        static void Main(string[] args)
        {
            var root = new Node("A");
            root.AddChild("B").AddChild("C").AddChild("D");

            var nodeB = root.Children[0];
            nodeB.AddChild("E").AddChild("F");
            
            var nodeD = root.Children[2];
            nodeD.AddChild("G").AddChild("H");

            var nodeF = nodeB.Children[1];
            nodeF.AddChild("I").AddChild("J");

            var nodeG = nodeD.Children[0];
            nodeG.AddChild("K");

            Console.Write(string.Join(", ", root.BreadthFirstSearch()));
            Console.WriteLine(string.Join(", ", root.DepthFirstSearch()));
        }
    }
}
