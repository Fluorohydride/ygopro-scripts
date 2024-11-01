--忘却の海底神殿
---@param c Card
function c43889633.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43889633,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c43889633.target)
	e2:SetOperation(c43889633.operation)
	c:RegisterEffect(e2)
	--code
	aux.EnableChangeCode(c,22702055)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43889633,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c43889633.spcon)
	e3:SetTarget(c43889633.sptg)
	e3:SetOperation(c43889633.spop)
	c:RegisterEffect(e3)
end
function c43889633.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsRace(RACE_FISH+RACE_SEASERPENT+RACE_AQUA) and c:IsAbleToRemove()
end
function c43889633.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c43889633.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43889633.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c43889633.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c43889633.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsRace(RACE_FISH+RACE_SEASERPENT+RACE_AQUA) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(43889634,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end
function c43889633.spfilter(c,fid)
	return c:GetFlagEffect(43889634)~=0 and c:GetFlagEffectLabel(43889634)==fid
end
function c43889633.spcon(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetHandler():GetFieldID()
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c43889633.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,fid)
end
function c43889633.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local fid=e:GetHandler():GetFieldID()
	local tg=Duel.GetMatchingGroup(c43889633.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,fid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c43889633.spop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetHandler():GetFieldID()
	local tg=Duel.GetMatchingGroup(c43889633.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,fid)
	if #tg>0 then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
