class quicksort {
  public static void main(String[] args) {
    double[] intArray = new double[6];
    intArray[0] = 5.0;
    intArray[1] = 2.0;
    intArray[2] = 6.0;
    intArray[3] = 1.0;
    intArray[4] = 3.0;
    intArray[5] = 4.0;
    quicksort(intArray, 0, 5);
  }

  private static int sum(int arr[], int size) {
    if (size == 0) {
      return 0;
    } else {
      return sum(arr, (size - 1)) + arr[size - 1];
    }
  }

  private static void quicksort(double[] arr, int first, int last) {
    if (first < last) {
      int part = partition(arr, first, last);
      quicksort(arr, first, (part - 1));
      quicksort(arr, part - 1, last);
    }
  }

  private static int partition(double[] arr, int first, int last) {
    double pivot = arr[last];
    int i = first;
    for (int j = first; first < last - 1; j++) {
      if (arr[j] <= pivot) {
        swap(arr[i], arr[j]);
        i++;
      }
    }
    swap(arr[i], arr[last]);
    return 0;
  }

  private static void swap(double firstValue, double secondValue) {

  }
}
