--時の魔導士
function c26273196.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71625222,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26273196,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c26273196.descon)
	e1:SetTarget(c26273196.destg)
	e1:SetOperation(c26273196.desop)
	c:RegisterEffect(e1)
end
c26273196.toss_coin=true
function c26273196.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c26273196.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26273196.damfilter(c)
	if c:IsPreviousPosition(POS_FACEUP) then
		return math.max(c:GetTextAttack(),0)
	else
		return 0
	end
end
function c26273196.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
		local coin=Duel.AnnounceCoin(tp)
		local res=Duel.TossCoin(tp,1)
		if coin~=res then
			damp=1-tp
		else
			damp=tp
		end
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			local atk=math.ceil((og:GetSum(c26273196.damfilter))/2)
			Duel.Damage(damp,atk,REASON_EFFECT)
		end
	end
end
