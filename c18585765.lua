--ボルテスター
---@param c Card
function c18585765.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18585765,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,18585765)
	e1:SetCondition(c18585765.descon)
	e1:SetTarget(c18585765.destg)
	e1:SetOperation(c18585765.desop)
	c:RegisterEffect(e1)
end
function c18585765.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c18585765.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(mc)
end
function c18585765.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c18585765.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18585765.desfilter2(g)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(18585766,RESET_CHAIN,0,1,fid)
		local lg=tc:GetLinkedGroup()
		local sc=lg:GetFirst()
		while sc do
			sc:RegisterFlagEffect(18585765,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
			sg:AddCard(sc)
			sc=lg:GetNext()
		end
		tc=g:GetNext()
	end
	return sg
end
function c18585765.desfilter3(c,g)
	local tc=g:GetFirst()
	while tc do
		local fid=tc:GetFlagEffectLabel(18585766)
		if fid~=nil and c:GetFlagEffectLabel(18585765)==fid then return true end
		tc=g:GetNext()
	end
	return false
end
function c18585765.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c18585765.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	local lg=c18585765.desfilter2(g)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local sg=lg:Filter(c18585765.desfilter3,e:GetHandler(),og)
		while sg:GetCount()>0 do
			Duel.BreakEffect()
			lg=c18585765.desfilter2(sg)
			if Duel.Destroy(sg,REASON_EFFECT)==0 then return end
			og=Duel.GetOperatedGroup()
			sg=lg:Filter(c18585765.desfilter3,e:GetHandler(),og)
		end
	end
end
