--斬機サーキュラー
---@param c Card
function c36521307.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36521307,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,36521307)
	e1:SetCost(c36521307.spcost)
	e1:SetTarget(c36521307.sptg)
	e1:SetOperation(c36521307.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36521307,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,36521308)
	e2:SetCondition(c36521307.thcon)
	e2:SetTarget(c36521307.thtg)
	e2:SetOperation(c36521307.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c36521307.costfilter(c)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and not c:IsCode(36521307) and c:IsAbleToGraveAsCost()
end
function c36521307.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36521307.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c36521307.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c36521307.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c36521307.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c36521307.checkop)
	Duel.RegisterEffect(e1,tp)
	--cannot announce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c36521307.atkcon)
	e2:SetTarget(c36521307.atktg)
	e1:SetLabelObject(e2)
	Duel.RegisterEffect(e2,tp)
end
function c36521307.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,36521307)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,36521307,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c36521307.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),36521307)>0
end
function c36521307.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c36521307.cfilter(c,tp)
	return c:IsSetCard(0x132) and c:IsControler(tp) and c:IsFaceup()
end
function c36521307.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36521307.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c36521307.thfilter(c)
	return c:IsSetCard(0x132) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c36521307.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36521307.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c36521307.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c36521307.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
