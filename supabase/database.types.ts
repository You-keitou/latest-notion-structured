export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      action_logs: {
        Row: {
          action_id: string
          completed_at: string
          created_at: string
          duration_minutes: number | null
          id: string
          user_id: string
        }
        Insert: {
          action_id: string
          completed_at?: string
          created_at?: string
          duration_minutes?: number | null
          id?: string
          user_id: string
        }
        Update: {
          action_id?: string
          completed_at?: string
          created_at?: string
          duration_minutes?: number | null
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "action_logs_action_id_fkey"
            columns: ["action_id"]
            isOneToOne: false
            referencedRelation: "actions"
            referencedColumns: ["id"]
          },
        ]
      }
      actions: {
        Row: {
          context: string | null
          created_at: string
          end_time: string | null
          energy_level: number | null
          id: string
          is_masked: boolean | null
          is_pinned: boolean | null
          notion_id: string | null
          project_id: string | null
          scheduled_date: string | null
          start_time: string | null
          status: string
          time_slot: string | null
          title: string
          updated_at: string
          user_id: string
        }
        Insert: {
          context?: string | null
          created_at?: string
          end_time?: string | null
          energy_level?: number | null
          id?: string
          is_masked?: boolean | null
          is_pinned?: boolean | null
          notion_id?: string | null
          project_id?: string | null
          scheduled_date?: string | null
          start_time?: string | null
          status?: string
          time_slot?: string | null
          title: string
          updated_at?: string
          user_id: string
        }
        Update: {
          context?: string | null
          created_at?: string
          end_time?: string | null
          energy_level?: number | null
          id?: string
          is_masked?: boolean | null
          is_pinned?: boolean | null
          notion_id?: string | null
          project_id?: string | null
          scheduled_date?: string | null
          start_time?: string | null
          status?: string
          time_slot?: string | null
          title?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "actions_project_id_fkey"
            columns: ["project_id"]
            isOneToOne: false
            referencedRelation: "projects"
            referencedColumns: ["id"]
          },
        ]
      }
      areas: {
        Row: {
          created_at: string
          id: string
          is_archived: boolean | null
          notion_id: string | null
          title: string
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_archived?: boolean | null
          notion_id?: string | null
          title: string
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          is_archived?: boolean | null
          notion_id?: string | null
          title?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      inbox_items: {
        Row: {
          content: string | null
          created_at: string
          id: string
          processed: boolean | null
          processed_at: string | null
          processed_into: string | null
          processed_item_id: string | null
          source: string | null
          title: string
          updated_at: string
          user_id: string
        }
        Insert: {
          content?: string | null
          created_at?: string
          id?: string
          processed?: boolean | null
          processed_at?: string | null
          processed_into?: string | null
          processed_item_id?: string | null
          source?: string | null
          title: string
          updated_at?: string
          user_id: string
        }
        Update: {
          content?: string | null
          created_at?: string
          id?: string
          processed?: boolean | null
          processed_at?: string | null
          processed_into?: string | null
          processed_item_id?: string | null
          source?: string | null
          title?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      notion_connections: {
        Row: {
          access_token: string
          created_at: string
          id: string
          is_active: boolean | null
          last_successful_sync: string | null
          updated_at: string
          user_id: string
          workspace_id: string | null
          workspace_name: string | null
        }
        Insert: {
          access_token: string
          created_at?: string
          id?: string
          is_active?: boolean | null
          last_successful_sync?: string | null
          updated_at?: string
          user_id: string
          workspace_id?: string | null
          workspace_name?: string | null
        }
        Update: {
          access_token?: string
          created_at?: string
          id?: string
          is_active?: boolean | null
          last_successful_sync?: string | null
          updated_at?: string
          user_id?: string
          workspace_id?: string | null
          workspace_name?: string | null
        }
        Relationships: []
      }
      notion_sync_logs: {
        Row: {
          completed_at: string | null
          details: Json | null
          error_message: string | null
          id: string
          items_processed: number | null
          started_at: string
          status: string
          sync_type: string
          user_id: string
        }
        Insert: {
          completed_at?: string | null
          details?: Json | null
          error_message?: string | null
          id?: string
          items_processed?: number | null
          started_at?: string
          status: string
          sync_type: string
          user_id: string
        }
        Update: {
          completed_at?: string | null
          details?: Json | null
          error_message?: string | null
          id?: string
          items_processed?: number | null
          started_at?: string
          status?: string
          sync_type?: string
          user_id?: string
        }
        Relationships: []
      }
      notion_sync_states: {
        Row: {
          created_at: string
          error_message: string | null
          id: string
          item_type: string
          last_local_update: string | null
          last_notion_update: string | null
          last_synced_at: string
          local_id: string
          notion_id: string
          sync_status: string
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          error_message?: string | null
          id?: string
          item_type: string
          last_local_update?: string | null
          last_notion_update?: string | null
          last_synced_at: string
          local_id: string
          notion_id: string
          sync_status?: string
          updated_at?: string
          user_id: string
        }
        Update: {
          created_at?: string
          error_message?: string | null
          id?: string
          item_type?: string
          last_local_update?: string | null
          last_notion_update?: string | null
          last_synced_at?: string
          local_id?: string
          notion_id?: string
          sync_status?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: []
      }
      projects: {
        Row: {
          area_id: string | null
          created_at: string
          desired_outcome: string | null
          id: string
          next_review_date: string | null
          notion_id: string | null
          status: string
          title: string
          updated_at: string
          user_id: string
        }
        Insert: {
          area_id?: string | null
          created_at?: string
          desired_outcome?: string | null
          id?: string
          next_review_date?: string | null
          notion_id?: string | null
          status?: string
          title: string
          updated_at?: string
          user_id: string
        }
        Update: {
          area_id?: string | null
          created_at?: string
          desired_outcome?: string | null
          id?: string
          next_review_date?: string | null
          notion_id?: string | null
          status?: string
          title?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "projects_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
        ]
      }
      review_action_items: {
        Row: {
          action_taken: string
          created_at: string
          id: string
          item_id: string
          item_type: string
          notes: string | null
          review_id: string
          user_id: string
        }
        Insert: {
          action_taken: string
          created_at?: string
          id?: string
          item_id: string
          item_type: string
          notes?: string | null
          review_id: string
          user_id: string
        }
        Update: {
          action_taken?: string
          created_at?: string
          id?: string
          item_id?: string
          item_type?: string
          notes?: string | null
          review_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "review_action_items_review_id_fkey"
            columns: ["review_id"]
            isOneToOne: false
            referencedRelation: "weekly_reviews"
            referencedColumns: ["id"]
          },
        ]
      }
      weekly_reviews: {
        Row: {
          actions_added_count: number | null
          actions_completed_count: number | null
          actions_reviewed: boolean | null
          areas_reviewed: boolean | null
          calendar_reviewed: boolean | null
          challenges: string[] | null
          completed_at: string | null
          created_at: string
          id: string
          inbox_cleared: boolean | null
          inbox_processed_count: number | null
          next_week_focus: string | null
          notes: string | null
          projects_reviewed: boolean | null
          projects_updated_count: number | null
          review_date: string
          someday_maybe_reviewed: boolean | null
          started_at: string | null
          status: string
          updated_at: string
          user_id: string
          wins: string[] | null
        }
        Insert: {
          actions_added_count?: number | null
          actions_completed_count?: number | null
          actions_reviewed?: boolean | null
          areas_reviewed?: boolean | null
          calendar_reviewed?: boolean | null
          challenges?: string[] | null
          completed_at?: string | null
          created_at?: string
          id?: string
          inbox_cleared?: boolean | null
          inbox_processed_count?: number | null
          next_week_focus?: string | null
          notes?: string | null
          projects_reviewed?: boolean | null
          projects_updated_count?: number | null
          review_date: string
          someday_maybe_reviewed?: boolean | null
          started_at?: string | null
          status?: string
          updated_at?: string
          user_id: string
          wins?: string[] | null
        }
        Update: {
          actions_added_count?: number | null
          actions_completed_count?: number | null
          actions_reviewed?: boolean | null
          areas_reviewed?: boolean | null
          calendar_reviewed?: boolean | null
          challenges?: string[] | null
          completed_at?: string | null
          created_at?: string
          id?: string
          inbox_cleared?: boolean | null
          inbox_processed_count?: number | null
          next_week_focus?: string | null
          notes?: string | null
          projects_reviewed?: boolean | null
          projects_updated_count?: number | null
          review_date?: string
          someday_maybe_reviewed?: boolean | null
          started_at?: string | null
          status?: string
          updated_at?: string
          user_id?: string
          wins?: string[] | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      get_inbox_stats: {
        Args: {
          p_user_id: string
        }
        Returns: {
          total_items: number
          unprocessed_items: number
          processed_last_24h: number
          oldest_unprocessed_date: string
        }[]
      }
      get_latest_weekly_review: {
        Args: {
          p_user_id: string
        }
        Returns: {
          id: string
          review_date: string
          status: string
          completed_at: string
        }[]
      }
      get_review_streak: {
        Args: {
          p_user_id: string
        }
        Returns: number
      }
      get_sync_stats: {
        Args: {
          p_user_id: string
        }
        Returns: {
          total_items: number
          synced_items: number
          pending_items: number
          conflict_items: number
          last_successful_sync: string
        }[]
      }
      initialize_weekly_review: {
        Args: {
          p_user_id: string
        }
        Returns: string
      }
      process_inbox_item: {
        Args: {
          p_inbox_item_id: string
          p_destination: Database["public"]["Enums"]["processed_destination_enum"]
          p_processed_item_id: string
        }
        Returns: undefined
      }
      update_sync_status: {
        Args: {
          p_user_id: string
          p_item_type: string
          p_local_id: string
          p_notion_id: string
          p_sync_status: string
          p_error_message?: string
        }
        Returns: undefined
      }
    }
    Enums: {
      inbox_source_enum:
        | "manual"
        | "email"
        | "meeting"
        | "thought"
        | "notion"
        | "other"
      processed_destination_enum:
        | "action"
        | "project"
        | "reference"
        | "someday_maybe"
        | "trash"
      time_slot_enum: "morning" | "afternoon" | "evening" | "night"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof PublicSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof PublicSchema["CompositeTypes"]
    ? PublicSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never
