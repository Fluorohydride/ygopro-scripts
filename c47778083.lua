--ボーン・テンプル・ブロック
function c47778083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c47778083.target)
	e1:SetOperation(c47778083.operation)
	c:RegisterEffect(e1)
end
function c47778083.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47778083.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0
			and Duel.IsExistingTarget(c47778083.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c47778083.filter,1-tp,0,LOCATION_GRAVE,1,nil,e,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
	end
	local tg=Group.CreateGroup()
	for p in aux.TurnPlayers() do
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(p,c47778083.filter,p,0,LOCATION_GRAVE,1,1,nil,e,p)
		tg:Merge(g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,2,0,0)
end
function c47778083.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local sg=Group.CreateGroup()
	for p in aux.TurnPlayers() do
		local tc=tg:Filter(Card.IsControler,nil,1-p):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP) then
			tc:RegisterFlagEffect(47778083,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tg:RemoveCard(tc)
			sg:AddCard(tc)
		end
	end
	Duel.SpecialSummonComplete()
	if #sg==0 then return end
	sg:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c47778083.descon)
	e1:SetOperation(c47778083.desop)
	e1:SetLabel(fid,Duel.GetTurnCount())
	e1:SetLabelObject(sg)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c47778083.desfilter(c,fid)
	return c:GetFlagEffectLabel(47778083)==fid
end
function c47778083.descon(e,tp,eg,ep,ev,re,r,rp)
	local fid,turnc=e:GetLabel()
	if Duel.GetTurnCount()==turnc then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c47778083.desfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c47778083.desop(e,tp,eg,ep,ev,re,r,rp)
	local fid,turnc=e:GetLabel()
	local g=e:GetLabelObject()
	local tg=g:Filter(c47778083.desfilter,nil,fid)
	Duel.Destroy(tg,REASON_EFFECT)
end
