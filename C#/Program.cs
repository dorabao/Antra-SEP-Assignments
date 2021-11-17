using System;

namespace MyConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] nums = { 1, 2, 1 };
            int[] result = CAssignment.ArrExpander(nums);
            Array.ForEach(result, Console.WriteLine);
        }
    }

    class CAssignment
    {
        public static int[] ArrExpander(int[] array)
        {
            if (array == null) return array;

            int expander = 2;
            int length = array.Length;
            int newLength = expander * length;

            int[] newArray = new int[newLength];
            for (int i = 0; i < newLength; i++)
            {
                newArray[i] = array[i % length];
            }
            return newArray;
        }
    }
}

