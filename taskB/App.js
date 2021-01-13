
import * as React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import  RecipesScreen  from './src/screens/Recipes';
import  RecipesMethodScreen  from './src/screens/RecipesMethod';
import  CategoriesScreen  from "./src/screens/Categories";
import  StartScreen from "./src/screens/Start";


const Stack = createStackNavigator();

function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Start">
        {/* start page */}
        <Stack.Screen name="Start" component={StartScreen} options={{ title: 'Start' }}/>
        {/* category page */}
        <Stack.Screen name="Categories" component={CategoriesScreen} options={{ title: 'Categories' }}/>
        {/* recipelist page */}
        <Stack.Screen name="Recipes" component={RecipesScreen} options={{ title: 'RecipeList' }}/>
        {/* recipe method page */}
        <Stack.Screen name="RecipeMethods" component={RecipesMethodScreen} options={{ title: 'RecipeMethods' }}/>
      </Stack.Navigator>
    </NavigationContainer>
  );
}

export default App;