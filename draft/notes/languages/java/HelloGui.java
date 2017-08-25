import javax.swing.*;
import java.awt.event.*;

public class HelloGui implements ActionListener {
    JButton button;
    private static int clickCount;

    public static void main(String [] args) {
  HelloGui gui = new HelloGui();
	gui.go();
    }

    public void go() {
	JFrame frame = new JFrame();
	button = new JButton("click me");
	button.addActionListener(this);

	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	frame.getContentPane().add(button);
	frame.setSize(300, 300);
	frame.setVisible(true);
    }

    public void actionPerformed(ActionEvent event) {
	clickCount++;
	button.setText("I've been clicked " + clickCount + " times!");
    }
}
