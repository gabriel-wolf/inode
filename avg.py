import csv
import pandas as pd


def read_csv_and_collect(input_csv):
    data = []

    with open(input_csv, 'r') as csvfile:
        csvreader = csv.DictReader(csvfile)
        
        for row in csvreader:
            data.append(row)

    return data

if __name__ == "__main__":
    # Specify the input CSV file path
    input_csv = 'avg1.csv'  # Replace with your input CSV file

    # Call the function to read CSV and collect values into a list of dictionaries
    result_data = read_csv_and_collect(input_csv)

    # Print the collected data
    # for row in result_data:
        # print(row)

    df = pd.DataFrame(result_data)
    
    df['Access Time'] = pd.to_datetime(df['Access Time'], format='%Y-%m-%d %H:%M:%S.%f %z', errors='coerce', utc=True)

    # Filter out rows with invalid 'Access Time'
    df = df[df['Access Time'].notna()]

    # Convert 'Access Time' to numeric for sum operation
    df['Access Time'] = pd.to_numeric(df['Access Time'])

    # Group by 'Parent Path' and sum up the 'Access Time' with utc=True
    result_df = df.groupby('Parent Path')['Access Time'].sum().reset_index()

    # Convert the sum back to datetime format with utc=True
    result_df['Access Time'] = pd.to_datetime(result_df['Access Time'], utc=True)
    
    
    result_df.to_csv('result.csv', index=False)
    # print(result_df)




