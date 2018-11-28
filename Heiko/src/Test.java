import java.awt.List;
import java.util.Collection;

public class Test {
	
	public static void main(String[] args)
	{



	}
	
	public static float[] arraysum(float[] arr1, float[] arr2)
	{
		float ret[] = new float[Math.max(arr1.length, arr2.length)];
		
		for(int i = 0; i < Math.min(arr1.length, arr2.length); i++)
		{
			ret[i] = arr1[i] + arr2[i];
		}
		
		for(int i = Math.min(arr1.length, arr2.length); 
				i < Math.max(arr1.length, arr2.length); i++)
		{
			if(arr1.length > arr2.length)
			{
				ret[i] = arr1[i];
			}
			else
			{
				ret[i] = arr2[i];
			}
		}
		
		return ret;
	}
	
}
