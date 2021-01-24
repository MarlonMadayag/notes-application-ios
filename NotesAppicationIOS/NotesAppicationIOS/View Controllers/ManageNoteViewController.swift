import UIKit

@available(iOS 13.0, *)
class ManageNoteViewController: UIViewController {
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isNewNote: Bool = true
    var noteDetail: Note?
    var noteColor: String = BackgroundColor.mercury.rawValue
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDetail: UITextView!
    
    @IBAction func btnLavender(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.lavender.rawValue)
    }
    @IBAction func btnHoneydew(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.honeydew.rawValue)
    }
    @IBAction func btnSky(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.sky.rawValue)
    }
    @IBAction func btnMercury(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.mercury.rawValue)
    }
    @IBAction func btnCantaloupe(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.cantaloupe.rawValue)
    }
    @IBAction func btnSalmon(_ sender: UIButton) {
        changeNoteDetailBackgroundColor(color: BackgroundColor.salmon.rawValue)
    }
    @IBAction func saveNote() {
        if tfTitle.text! == "" && tfDetail.text! == "" {
            tfDetail.layer.borderWidth = 1
            tfDetail.layer.borderColor = UIColor.red.cgColor
        }
        else {
            createNote()
            performSegue(withIdentifier: "unwindToNotesViewController", sender: self)
        }
    }
    @IBAction func deleteNote() {
        showDeleteNoteModalConfirmation()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add navigation bar add note button
        let save = UIBarButtonItem(title: isNewNote ? "Add" : "Update", style: .plain, target: self, action: #selector(saveNote))
        
        if isNewNote {
            navigationItem.rightBarButtonItems = [save]
        }
        else {
            let delete = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteNote))
            delete.tintColor = UIColor.red
            navigationItem.rightBarButtonItems = [save, delete]
        }
        
        
        configureNoteOnLoad()
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    func showDeleteNoteModalConfirmation() {
        // Create alert
        let alert = UIAlertController(title: "Delete note?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // Which note to remove
            let noteToRemove = self.noteDetail
            
            // Remove the note
            self.context.delete(noteToRemove!)
            
            // Save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.performSegue(withIdentifier: "unwindToNotesViewController", sender: self)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        })
        
        
        //Show alert
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    func configureNoteOnLoad() {
        tfDetail.layer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        if isNewNote {
            tfTitle.text = ""
            tfDetail.text = ""
        }
        else {
            tfTitle.text = noteDetail?.title
            tfDetail.text = noteDetail?.detail
            changeNoteDetailBackgroundColor(color: (noteDetail?.color)!)
        }
    }
    
    func changeNoteDetailBackgroundColor(color: String) {
        self.noteColor = color
        
        switch color {
        case BackgroundColor.lavender.rawValue:
            tfDetail.layer.backgroundColor = #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        case "honeydew":
            tfDetail.layer.backgroundColor = #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)
        case "sky":
            tfDetail.layer.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        case "cantaloupe":
            tfDetail.layer.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "salmon":
            tfDetail.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        default:
            tfDetail.layer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }
    
    func createNote() {
        // Create a new note object
        let note = isNewNote ? Note(context: self.context) : self.noteDetail

        note!.title = tfTitle.text
        note!.detail = tfDetail.text
        note!.createdDate = Date()
        note!.color = noteColor
        
        
        // Save the data
        do {
            try self.context.save()
        }
        catch {
            
        }
        
    }

}
