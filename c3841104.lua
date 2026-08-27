--解層竜ストラティアエ
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.atkcon)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--fusion summon
	local e3=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE|LOCATION_GRAVE,
		mat_operation_code_map={
			{[LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE},
			{[0xff]=FusionSpell.FUSION_OPERATION_BANISH}
		},
		extra_target=s.extra_target,
		stage_x_operation=s.stage_x_operation
	})
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	c:RegisterEffect(e3)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_DINOSAUR)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local atk=0
	for tc in aux.Next(g) do
		if tc:IsLinkRace(RACE_DINOSAUR) and aux.covcheck(tc) then
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
		end
	end
	e:GetLabelObject():SetLabel(atk)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToChain()) then return end
	local atk=e:GetLabel()
	if atk==0 then return end
	atk=math.ceil(atk/2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function s.fusfilter(c)
	return c:IsRace(RACE_DINOSAUR)
end
function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end
function s.stage_x_operation(fe,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_ALL_OPERATION_FINISH then
		local c=fe:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DINOSAUR)
end
