using System.Collections.Generic;

namespace ConsoleApp2
{
    public class Node
    {
        public string Name { get; }

        public List<Node> Children { get; } = new List<Node>();

        public Node(string name)
        {
            Name = name;
        }

        public List<string> DepthFirstSearch()
        {
            var names = new List<string>();
            DepthFirstSearch(this, names);
            return names;
        }

        private void DepthFirstSearch(Node root, List<string> names)
        {
            if (root == null) return;

            names.Add(root.Name);
            foreach (var childNode in root.Children)
            {
                DepthFirstSearch(childNode, names);
            }
        }

        public List<string> BreadthFirstSearch()
        {
            var names = new List<string>();
            var queue = new Queue<Node>();
            
            queue.Enqueue(this);
            while (queue.Count != 0)
            {
                var node = queue.Dequeue();
                names.Add(node.Name);

                foreach (var childNode in node.Children)
                {
                    queue.Enqueue(childNode);
                }
            }

            return names;
        }

        public Node AddChild(string name)
        {
            Node child = new Node(name);
            Children.Add(child);
            return this;
        }
    }
}
