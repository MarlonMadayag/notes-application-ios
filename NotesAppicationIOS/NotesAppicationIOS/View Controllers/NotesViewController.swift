import UIKit
import CoreData

@available(iOS 13.0, *)
class NotesViewController: UIViewController {
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var notes: [Note]?
    var noteDetail: Note?
    var isNewNote: Bool = true
    
    @IBOutlet weak var tvNotes: UITableView!
    
    @IBAction func unwindToNotesViewController(_ seg: UIStoryboardSegue) {
        fetchNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tvNotes.delegate = self
        tvNotes.dataSource = self
        
        navigationController?.navigationBar.topItem?.title = "Notes"
        
        // Add navigation bar add note button
        let add = UIBarButtonItem(title: "Add new note", style: .plain, target: self, action: #selector(transitionToManageNoteViewController))
//        let addIcon = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        navigationItem.rightBarButtonItems = [add]
        // Get notes from core data
        fetchNotes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ManageNoteViewController
        {
            let vc = segue.destination as! ManageNoteViewController
            
            vc.isNewNote = self.isNewNote
            vc.noteDetail = self.noteDetail
        }
    }
    
    @IBAction func transitionToManageNoteViewController() {
        self.isNewNote = true
        performSegue(withIdentifier: "ManageNoteViewController", sender: self)
    }
    
    func fetchNotes() {
        // Fetch the data from the core data to display in the tableview
        do {
            let request = Note.fetchRequest() as NSFetchRequest<Note>
            let sort = NSSortDescriptor(key: "createdDate", ascending: false)
            
            request.sortDescriptors = [sort]
            
            self.notes = try context.fetch(request)

            DispatchQueue.main.async {
                self.tvNotes.reloadData()
            }
        }
        catch {
            
        }
    }
}

@available(iOS 13.0, *)
extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.noteDetail = notes![indexPath.row]
        self.isNewNote = false
        performSegue(withIdentifier: "ManageNoteViewController", sender: self)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // Which note to remove
            let noteToRemove = self.notes![indexPath.row]
            
            // Remove the note
            self.context.delete(noteToRemove)
            
            // Save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            // Re-fetch the data
            self.fetchNotes()
        }
        // Return swipe action
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

@available(iOS 13.0, *)
extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        let note = self.notes![indexPath.row]
        
        cell.lblNoteTitle.text = note.title
        cell.lblNoteDetail.text = note.detail
        
        switch note.color {
        case BackgroundColor.lavender.rawValue:
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)
        case "honeydew":
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)
        case "sky":
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        case "cantaloupe":
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "salmon":
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        default:
            cell.viewCellContainer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        
        // get the date time String from the date object
        cell.lblNoteCreatedDate.text = formatter.string(from: note.createdDate!) // October 8, 2016 at 10:48:53 PM
        
        return cell
    }
}
