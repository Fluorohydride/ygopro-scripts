--ホルスの加護－ケベンセヌフ
---@param c Card
function c74725513.initial_effect(c)
	aux.AddCodeList(c,16528181)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,74725513+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c74725513.sprcon)
	c:RegisterEffect(e1)
	--Leave Field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74725513,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,74725514)
	e2:SetCondition(c74725513.descon)
	e2:SetOperation(c74725513.desop)
	c:RegisterEffect(e2)
end
function c74725513.sprfilter(c)
	return c:IsFaceup() and c:IsCode(16528181)
end
function c74725513.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c74725513.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c74725513.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function c74725513.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74725513.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c74725513.atlimit(e,c)
	return c:IsSetCard(0x19d) and c:IsFaceup()
end
function c74725513.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c74725513.atlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c74725513.atlimit)
	e2:SetValue(aux.tgoval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
