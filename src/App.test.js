import { render, screen } from "@testing-library/react";
import App from "./App";

test('renders form heading', () => {
  render(<App />);
  const headingElement = screen.getByText(/Form in React/i);
  expect(headingElement).toBeInTheDocument();
});
