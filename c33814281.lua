--特許権の契約書類
function c33814281.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c33814281.spcon)
	e2:SetTarget(c33814281.sptg)
	e2:SetOperation(c33814281.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33814281)
	e3:SetTarget(c33814281.thtg)
	e3:SetOperation(c33814281.thop)
	c:RegisterEffect(e3)
end
function c33814281.limfilter(c,tp)
	local rtype=c:GetType()&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
	return c:GetSummonPlayer()==1-tp and rtype>0
		and Duel.IsExistingMatchingCard(c33814281.cfilter,tp,LOCATION_MZONE,0,1,nil,rtype)
end
function c33814281.cfilter(c,rtype)
	return c:IsFaceup() and c:IsSetCard(0x10af) and c:GetType()&rtype>0
end
function c33814281.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33814281.limfilter,1,nil,tp)
end
function c33814281.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c33814281.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	local c=e:GetHandler()
	local g=eg:Filter(c33814281.limfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local rtype=tc:GetType()&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
		local reset=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetRange(LOCATION_FZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(reset)
		e1:SetTargetRange(0,1)
		e1:SetLabel(rtype)
		e1:SetTarget(c33814281.sumlimit)
		c:RegisterEffect(e1)
		if (rtype&TYPE_FUSION)>0 and c:GetFlagEffect(33814281)==0 then
			c:RegisterFlagEffect(33814281,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33814281,0))
		end
		if (rtype&TYPE_SYNCHRO)>0 and c:GetFlagEffect(33814282)==0 then
			c:RegisterFlagEffect(33814282,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33814281,1))
		end
		if (rtype&TYPE_XYZ)>0 and c:GetFlagEffect(33814283)==0 then
			c:RegisterFlagEffect(33814283,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33814281,2))
		end
		if (rtype&TYPE_LINK)>0 and c:GetFlagEffect(33814284)==0 then
			c:RegisterFlagEffect(33814284,reset,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33814281,3))
		end
		tc=g:GetNext()
	end
end
function c33814281.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(e:GetLabel())
end
function c33814281.thfilter(c)
	return (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) or c:IsLocation(LOCATION_GRAVE))
		and c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33814281.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33814281.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c33814281.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33814281.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
