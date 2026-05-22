[update_workflow.md](https://github.com/user-attachments/files/28142203/update_workflow.md)
# Create / Update Agent Workflow Visualization

Read the three agent definition files and the current workflow.html, then update the workflow.html to replace each column body with a Mermaid flow diagram while keeping the column headers intact.

## Steps

1. Read these source files:
    - Switch to the folder ~/.config/opencode
    - `agents/software_architect.md` — defines the architect's tasks, approval loops, and handoff to engineer/tester
    - `agents/software_engineer.md` — defines the engineer's implementation, test-writing, and test-pass loop
    - `agents/software_tester.md` — defines the tester's e2e test design, context-gathering, pass/fail branching, and bug reporting
    - `agents/workflow.html` — current workflow page (reference for structure, styling, and column layout)

2. Update `agents/workflow.html`:
    - Keep all column headers as they are
    - Keep the overall layout
    - Keep the Mermaid CDN script and initialization in `<head>` (add if missing)

3. Design each Mermaid diagram based on the agent definition files
    - only update the mermaid diagrams

4. Style constraints:
    - Use Mermaid `dark` theme to match the existing dark background
    - Use `&lt;br&gt;` for line breaks inside mermaid node labels (Mermaid renders `<br>` when inside `""` strings and `htmlLabels: true`)
    - Use `&amp;` for ampersands in node text
    - Keep the existing CSS for column layout, headers, arrows

## Verification
Open the updated `workflow.html` in a browser. Confirm:
- All columns render with correct headers
- Each Mermaid diagram renders with the correct flow and decision nodes
- Loops (feedback arrows) are visually distinct from forward flow
- Dark theme is consistent throughout
