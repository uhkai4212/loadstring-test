end

submitButton.MouseButton1Click:Connect(function()

    if keyTextBox.Text == correctKey then

        loadGunfightScript()

    else

        keyErrorLabel.Text = "Incorrect key. Please try again."

    end

end)