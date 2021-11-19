using System;

namespace Exercise7
{
    class Program
    {
        public class BankAccount
        {
            private int balance = 1000;

            public int CheckBalance()
            {
                return balance;
            }
            public void Withdraw(int value)
            {
                if (value >= 0 && value <= balance)
                {
                    balance -= value;
                    Console.WriteLine("Success");
                }
                else 
                {
                    Console.WriteLine("Fail");
                }
            }
            public void Deposit(int value)
            {
                if (value >= 0)
                {
                    balance += value;
                    Console.WriteLine("Success");
                }
                else
                {
                    Console.WriteLine("Fail");
                }
            }
        }
       


        static void Main(string[] args)
        {
            Console.WriteLine("Enter Your Pin Number:");
            int pin = Convert.ToInt32(Console.ReadLine());
            if (pin == 123)
            {
                BankAccount account = new BankAccount();
                bool exit = false;
                while (!exit)
                {
                    Console.WriteLine("********Welcome to ATM Service**************");
                    Console.WriteLine("1. Check Balance");
                    Console.WriteLine("2. Withdraw Cash");
                    Console.WriteLine("3. Deposit Cash");
                    Console.WriteLine("4. Quit");
                    Console.WriteLine("*********************************************");
                    int option = Convert.ToInt32(Console.ReadLine());
                    switch (option)
                    {
                        case 1:
                            Console.WriteLine($"YOU'RE BALANCE IN Rs: {account.CheckBalance()}");
                            break;
                        case 2:
                            Console.Write("Input The Amount:");
                            int amountD = Convert.ToInt32(Console.ReadLine());
                            account.Withdraw(amountD);
                            break;
                        case 3:
                            Console.Write("Input The Amount:");
                            int amountA = Convert.ToInt32(Console.ReadLine());
                            account.Deposit(amountA);
                            break;
                        case 4:
                            exit = true;
                            Console.WriteLine("Thank you! Good Bye!");
                            break;
                        default:
                            Console.WriteLine("Invalid option");
                            break;
                    }
                }
            }
        }
    }
}
