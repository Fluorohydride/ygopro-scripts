--ジェムナイト・ディスパージョン
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,1264319)
	local e0=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=s.pre_select_mat_location,
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		additional_fcheck=s.fcheck
	})
	--Activate 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|CATEGORY_SEARCH|CATEGORY_TOHAND|CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end
function s.filter0(c)
	return c:IsSetCard(0x1047) and not c:IsRace(RACE_ROCK)
		and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end

function s.fusfilter(c)
	return c:IsSetCard(0x1047)
end

--- @type FUSION_SPELL_PRE_SELECT_MAT_LOCATION_FUNCTION
function s.pre_select_mat_location(tc,tp)
	local location=LOCATION_HAND|LOCATION_MZONE
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,1264319) then
		location=location|LOCATION_DECK|LOCATION_EXTRA
	end
	return location
end

function s.fusion_spell_matfilter(c)
	--- materials from deck/extra must be ジェムナイト
	if c:IsLocation(LOCATION_DECK|LOCATION_EXTRA) and not c:IsFusionSetCard(0x1047) then
		return false
	end
	return true
end

function s.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x47) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,all_mg)
	--- if we have this, we already know there is ジェムナイト・フュージョン in GY
	local mg_deck=mg:Filter(function(c) return c:IsLocation(LOCATION_DECK|LOCATION_EXTRA) end,nil)
	--- Up to 2 monsters from your Deck/Extra Deck can be used,
	if #mg_deck>2 then
		return false
	end
	--- Only if they are non-Rock "Gem-Knight" monsters
	if mg_deck:IsExists(function(c) return c:IsRace(RACE_ROCK) end,1,nil) then
		return false
	end
	return true
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fusion_effect=e:GetLabelObject()
	local res=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
	local b1=res and (Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
		and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and not b2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		op=1
	end
	if b2 and not b1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
		op=2
	end
	if b1 and b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|CATEGORY_DECKDES)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SEARCH|CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local fusion_effect=e:GetLabelObject()
		fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if Duel.GetFlagEffect(tp,51831560)==0 then
			Duel.RegisterFlagEffect(tp,51831560,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetCondition(s.damcon)
			e1:SetValue(s.damval)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.damval(e,re,val,r,rp,rc)
	if r&REASON_EFFECT==REASON_EFFECT then
		return math.ceil(val/2)
	else return val end
end
