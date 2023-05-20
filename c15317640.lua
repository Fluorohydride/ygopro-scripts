--巨大戦艦 カバード・コア
function c15317640.initial_effect(c)
	c:EnableCounterPermit(0x1f)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15317640,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c15317640.addct)
	e1:SetOperation(c15317640.addc)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(10)
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(Auxiliary.RemoveCondtion)
	e3:SetTarget(c15317640.rcttg)
	e3:SetOperation(c15317640.rctop)
	c:RegisterEffect(e3)
end
c15317640.toss_coin=true
function c15317640.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1f)
end
function c15317640.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1f,2)
	end
end
function c15317640.rcttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c15317640.rctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if coin==res then
		if c:IsRelateToEffect(e) then
			if c:IsCanRemoveCounter(tp,0x1f,1,REASON_EFFECT) then
				c:RemoveCounter(tp,0x1f,1,REASON_EFFECT)
			else
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end
