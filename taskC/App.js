import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import LoginScreen from './src/LoginScreen';
import SignupScreen from './src/SignupScreen';
import ProductHomeScreen from './src/ProductHomeScreen';
import ProductPostScreen from './src/ProductPostScreen';
import ProductViewAllScreen from './src/ProductViewAllScreen';
import ProductViewMyScreen from './src/ProductViewMyScreen';
import ShowImageScreen from './src/ShowImageScreen';
import ProductUpdateShowScreen from './src/ProductUpdateShowScreen'

import { createStore } from 'redux'
import imagesReducers from "./src/reducers/index";
import { Provider } from 'react-redux'

// create store : redux
const store = createStore(imagesReducers)

const Stack = createStackNavigator();

function App() {
  return (
    <Provider store={store}>
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Login">
          <Stack.Screen name="Login" component={LoginScreen} options={{ title: 'Login' }} />
          <Stack.Screen name="SignUp" component={SignupScreen} options={{ title: 'Sign up' }} />
          <Stack.Screen name="ShowImage" component={ShowImageScreen} options={{ title: 'Show Image' }} />
          <Stack.Screen name="ProductHome" component={ProductHomeScreen} options={{ title: 'Home' }} />
          <Stack.Screen name="ProductPost" component={ProductPostScreen} options={{ title: 'Post Ads' }} />
          <Stack.Screen name="ProductViewAll" component={ProductViewAllScreen} options={{ title: 'View All Ads' }} />
          <Stack.Screen name="ProductViewMy" component={ProductViewMyScreen} options={{ title: 'View My Ads' }} />
          <Stack.Screen name="UpdateShow" component={ProductUpdateShowScreen} options={{ title: 'Update My Ads' }} />
        </Stack.Navigator>
      </NavigationContainer>
    </Provider>
  );
}

export default App;


