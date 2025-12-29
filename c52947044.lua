--フュージョン・デステニー
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_DECK,
		stage_x_operation=s.stage_x_operation,
		additional_fcheck=s.fcheck
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return aux.IsMaterialListSetCard(c,0xc008)==true
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	--- Must include 1 Destiny HERO monster as material
	if not mg_all:IsExists(function(c) return c:IsFusionSetCard(0xc008) end,1,nil) then
		return false
	end
	return true
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(s.descon)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	elseif stage==FusionSpell.STAGE_AT_ALL_OPERATION_FINISH then
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(s.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function s.splimit(e,c)
	return not (c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x8))
end
