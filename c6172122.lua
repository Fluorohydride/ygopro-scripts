--真紅眼融合
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_HAND|LOCATION_MZONE|LOCATION_DECK,
		additional_fcheck=s.fcheck,
		stage_x_operation=s.stage_x_operation
	})
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(s.splimit)
	Duel.RegisterEffect(e2,tp)
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end

function s.fusfilter(c)
	return aux.IsMaterialListSetCard(c,0x3b)
end

--- @type FUSION_FGCHECK_FUNCTION
function s.fcheck(tp,mg,fc,mg_all)
	if fc.red_eyes_fusion_check~=nil then
		return fc.red_eyes_fusion_check(tp,mg_all,fc)==true
	end
	return mg_all:IsExists(Card.IsFusionSetCard,1,nil,0x3b)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(74677422)  --- 真紅眼の黒竜
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
