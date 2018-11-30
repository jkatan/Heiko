import javax.management.RuntimeErrorException;
public class Heiko{
public static float[] sumarrays (float[] arr1, float[] arr2){
float ret[] = new float[Math.max(arr1.length, arr2.length)];
for(int i = 0; i < Math.min(arr1.length, arr2.length); i++){
ret[i] = arr1[i] + arr2[i];
}for(int i = Math.min(arr1.length, arr2.length); i < Math.max(arr1.length, arr2.length); i++){
if(arr1.length < arr2.length){
ret[i] = arr2[i];
}
else{
ret[i] = arr1[i];
}
}
return ret;
}
public static float[] subarrays(float[] arr1, float[] arr2){
float ret[] = new float[Math.max(arr1.length, arr2.length)];
for(int i = 0; i < Math.min(arr1.length, arr2.length); i++){
ret[i] = arr1[i] - arr2[i];
}
	for(int i = Math.min(arr1.length, arr2.length); i < Math.max(arr1.length, arr2.length); i++){
if(arr1.length < arr2.length){
ret[i] = -arr2[i];
}
else{
ret[i] = arr1[i];
}
}
return ret;
}
public static float multarrays(float[] arr1, float[] arr2){
float ret = 0;
for(int i = 0; i < Math.min(arr1.length, arr2.length); i++){
ret += (arr1[i] * arr2[i]);
}
return ret;
}
public static float[][] summatrix(float[][] m1, float[][] m2){
float[][] ret = new float[Math.max(m1.length, m2.length)][Math.max(m1[0].length, m2[0].length)];
for(int i = 0; i < Math.max(m1.length, m2.length); i++){
if(i < Math.min(m1.length, m2.length)){
for(int j = 0; j < Math.max(m1[0].length, m2[0].length); j++){
if(j < Math.min(m1[0].length, m2[0].length)){
ret[i][j] = m1[i][j] + m2[i][j];
}
else if(m1[0].length > m2[0].length){
ret[i][j] = m1[i][j];
}
else{
ret[i][j] = m2[i][j];
}
}
}
else if(m1.length > m2.length){
for(int j = 0; j < m1[0].length; j++){
ret[i][j] = m1[i][j];
}
}
else{
for(int j = 0; j < m2[0].length; j++){
ret[i][j] = m2[i][j];
}
}
}
return ret;
}
public static float[][] submatrix(float[][] m1, float[][] m2){
float[][] ret = new float[Math.max(m1.length, m2.length)][Math.max(m1[0].length, m2[0].length)];
for(int i = 0; i < Math.max(m1.length, m2.length); i++){
if(i < Math.min(m1.length, m2.length)){
for(int j = 0; j < Math.max(m1[0].length, m2[0].length); j++){
if(j < Math.min(m1[0].length, m2[0].length)){
ret[i][j] = m1[i][j] - m2[i][j];
}
else if(m1[0].length > m2[0].length){
ret[i][j] = m1[i][j];
}
else{
ret[i][j] = -m2[i][j];
}
}
}
else if(m1.length > m2.length){
for(int j = 0; j < m1[0].length; j++){
ret[i][j] = m1[i][j];
}
}
else{
for(int j = 0; j < m2[0].length; j++){
ret[i][j] = -m2[i][j];
}
}
}
return ret;
}
public static float[][] multmatrix(float[][] m1, float[][] m2){
float[][] ret = new float[m1.length][m2[0].length];
if(m1.length != m2[0].length){
throw new RuntimeErrorException(null);
}
for(int i = 0; i < m1.length; i++){
for(int j = 0; j < m2[0].length; j++){
for(int k = 0; k < m2.length; k++){
ret[i][j] += m1[i][k] * m2[k][j];
}
}
}
return ret;
}
public static void printmatrix(float[][] m){
for(int i = 0; i < m.length; i++){
for(int j = 0; j < m[0].length; j++){
System.out.print(m[i][j]);
if(j != m[0].length - 1){
System.out.print(", ");
}
}
System.out.println("");
}
}
public static void printarray(float[] arr){
for(int i = 0; i < arr.length; i++){
System.out.print(arr[i]);
if(i != arr.length - 1){
System.out.print(", ");
}
}
System.out.println("");
}
public static void main(String[] args) 
{
	float a;
	float b = a;
}
}
