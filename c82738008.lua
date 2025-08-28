--赫の烙印
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--- fusion effect
	local e0=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		matfilter=aux.NecroValleyFilter(),
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		stage_x_operation=s.stage_x_operation
	})
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end

function s.filter(c)
	return (c:IsSetCard(0x164) and c:IsType(TYPE_MONSTER) or c:IsCode(68468459)) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.fusfilter(c)
	return c:IsLevelAbove(8)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local fusion_effect=e:GetLabelObject()
		if fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_SUMMON_COMPLETE then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
