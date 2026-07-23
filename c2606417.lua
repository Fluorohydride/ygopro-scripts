--大逆転BOX
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,40235813)
	c:EnableCounterPermit(0x76)
	c:SetCounterLimit(0x76,6)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.atkcon)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_COIN+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(s.atkcon2)
	e4:SetCost(s.atkcost)
	e4:SetTarget(s.atktg2)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
end
s.mentioned_counter={
	[0x76]=true,
}
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.TossDice(tp,1)
	if c:GetCounter(0x76)+ct>6 then ct=6-c:GetCounter(0x76) end
	if ct>0 then
		if ct>1 then
			local tb={}
			for i=ct,1,-1 do
				table.insert(tb,i)
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			ct=Duel.AnnounceNumber(tp,1,table.unpack(tb))
		end
		c:AddCounter(0x76,ct)
	end
end
function s.mfilter(c)
	return c:IsOnField() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and (not c:GetAttack()==0 or not c:IsDisabled())
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(1-tp) and s.mfilter(a)
end
function s.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and rc:IsRelateToEffect(re) and s.mfilter(rc)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x76,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x76,1,REASON_COST)
end
function s.spfilter(c,e,tp)
	return aux.IsCodeListed(c,40235813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	if chkc then return false end
	if chk==0 then return a:IsCanBeEffectTarget(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return tc:IsOnField() and tc:IsCanBeEffectTarget(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if coin~=res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
			and tc:IsFaceup() and tc:IsRelateToChain() and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetValue(0)
			tc:RegisterEffect(e3)
		end
	end
end
